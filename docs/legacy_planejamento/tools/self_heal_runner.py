#!/usr/bin/env python3
"""
Self-Healing Test Runner - [AGENT-SELFHEAL]

Capabilities:
- Parse flutter test --machine JSON output
- Cluster failures by root cause (error patterns)
- Suggest fixes based on common patterns
- Generate actionable reports for developers

Production enhancements:
- RAG integration for historical fix lookup
- Automated patch generation and testing
- Git sandbox branch creation
- PR auto-creation for passing fixes
"""

import json
import sys
import re
from pathlib import Path
from collections import defaultdict
from typing import List, Dict, Tuple

def parse_flutter_test_json(json_path: str) -> List[Dict]:
    """Parse flutter test --machine JSON output."""
    failures = []

    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    event = json.loads(line.strip())
                    event_type = event.get('type', '')

                    # Capture test failures
                    if event_type == 'error':
                        failures.append({
                            'test': event.get('testName', 'unknown'),
                            'error': event.get('error', ''),
                            'stackTrace': event.get('stackTrace', ''),
                            'type': 'runtime_error'
                        })
                    elif event_type == 'testDone' and event.get('result') == 'error':
                        failures.append({
                            'test': event.get('test', {}).get('name', 'unknown'),
                            'error': event.get('testID', ''),
                            'type': 'test_failure'
                        })
                except (json.JSONDecodeError, KeyError) as e:
                    continue
    except FileNotFoundError:
        print(f"❌ File not found: {json_path}")
        return []

    return failures

def cluster_failures(failures: List[Dict]) -> Dict[str, List[Dict]]:
    """Cluster failures by error pattern (root cause)."""
    clusters = defaultdict(list)

    for failure in failures:
        error_msg = failure.get('error', '')
        stack = failure.get('stackTrace', '')

        # Pattern matching for common error categories
        if 'Expected' in error_msg and ('Actual' in error_msg or 'to be' in error_msg):
            root_cause = 'assertion_mismatch'
        elif 'Null check operator' in error_msg or 'null' in error_msg.lower():
            root_cause = 'null_safety_violation'
        elif 'RangeError' in error_msg or 'index' in error_msg.lower():
            root_cause = 'index_out_of_bounds'
        elif 'NoSuchMethodError' in error_msg:
            root_cause = 'method_not_found'
        elif 'StateError' in error_msg or 'Invalid state' in error_msg:
            root_cause = 'invalid_state'
        elif 'TimeoutException' in error_msg or 'timed out' in error_msg.lower():
            root_cause = 'test_timeout'
        elif 'RenderFlex overflowed' in error_msg or 'overflow' in error_msg.lower():
            root_cause = 'ui_overflow'
        elif 'ProviderNotFoundException' in error_msg:
            root_cause = 'riverpod_provider_not_found'
        elif 'Finder' in error_msg and 'zero widgets' in error_msg:
            root_cause = 'widget_not_found'
        else:
            # Fallback: use first 50 chars of error as cluster key
            first_chars = error_msg[:50].strip()
            if first_chars:
                root_cause = f'other_{abs(hash(first_chars)) % 1000:03d}'
            else:
                root_cause = 'unknown'

        clusters[root_cause].append(failure)

    return clusters

def suggest_fix(root_cause: str, count: int) -> str:
    """Generate fix suggestion based on root cause."""

    fix_database = {
        'assertion_mismatch': f"""
🔧 Fix Strategy: Update test expectation or implementation
   Affected tests: {count}

   Pattern: Test expects different value than actual result

   Solutions:
   1. Update test if expectation is wrong:
      expect(result, matcher) → expect(result, correctMatcher)

   2. Fix implementation if logic is wrong:
      Review business logic returning unexpected value

   3. Check for timing issues:
      await tester.pumpAndSettle() before assertions""",

        'null_safety_violation': f"""
🔧 Fix Strategy: Handle null values properly
   Affected tests: {count}

   Pattern: Accessing null value without null check

   Solutions:
   1. Add null assertion operator if value guaranteed:
      final value = data['key']!;

   2. Use null-aware operators:
      final value = data['key'] ?? defaultValue;

   3. Make type nullable:
      final String? value = data['key'];""",

        'index_out_of_bounds': f"""
🔧 Fix Strategy: Add bounds checking
   Affected tests: {count}

   Pattern: Accessing list/array beyond valid range

   Solutions:
   1. Check length before access:
      if (index < list.length) {{ final item = list[index]; }}

   2. Use safe access:
      final item = list.elementAtOrNull(index);

   3. Review loop conditions:
      for (int i = 0; i < list.length; i++)""",

        'test_timeout': f"""
🔧 Fix Strategy: Optimize or increase timeout
   Affected tests: {count}

   Pattern: Test taking longer than default timeout

   Solutions:
   1. Increase timeout:
      testWidgets('test', (tester) async {{
        await tester.pumpAndSettle(
          timeout: const Duration(seconds: 10)
        );
      }});

   2. Use pump() instead of pumpAndSettle()  for known frame count

   3. Mock slow operations in tests""",

        'ui_overflow': f"""
🔧 Fix Strategy: Handle layout constraints
   Affected tests: {count}

   Pattern: Widget content exceeds available space

   Solutions:
   1. Wrap in Expanded/Flexible:
      Row(children: [Expanded(child: widget)])

   2. Add overflow handling:
      Text('...', overflow: TextOverflow.ellipsis)

   3. Use scrollable widgets:
      SingleChildScrollView(child: widget)""",

        'riverpod_provider_not_found': f"""
🔧 Fix Strategy: Fix Riverpod provider scope
   Affected tests: {count}

   Pattern: Provider accessed outside ProviderScope

   Solutions:
   1. Wrap test widget in ProviderScope:
      await tester.pumpWidget(
        const ProviderScope(child: MyApp())
      );

   2. Override providers in tests:
      ProviderScope(
        overrides: [myProvider.overrideWith(...)],
        child: MyApp()
      )""",

        'widget_not_found': f"""
🔧 Fix Strategy: Fix widget finder or timing
   Affected tests: {count}

   Pattern: Test cannot find expected widget

   Solutions:
   1. Wait for widget to appear:
      await tester.pumpAndSettle();

   2. Use more specific finder:
      find.byKey(Key('specific-key'))
      find.byType(SpecificWidget)

   3. Check conditional rendering logic""",
    }

    return fix_database.get(root_cause, f"""
🔧 Manual Inspection Required
   Affected tests: {count}
   Pattern: {root_cause}

   Review error messages and stack traces individually.
   Consider adding this pattern to fix database.""")

def analyze_failures(test_results_json: str) -> List[Tuple[str, int, str]]:
    """Main analysis function."""
    print("🔧 [AGENT-SELFHEAL] Analyzing test failures...")
    print(f"📄 Input: {test_results_json}\n")

    failures = parse_flutter_test_json(test_results_json)

    if not failures:
        print("✅ No failures detected in test results")
        return []

    clusters = cluster_failures(failures)

    print(f"📊 Clustered {len(failures)} failures into {len(clusters)} root cause(s):\n")
    print("=" * 80)

    results = []
    for root_cause, items in sorted(clusters.items(), key=lambda x: -len(x[1])):
        count = len(items)
        fix = suggest_fix(root_cause, count)

        print(f"\n🔴 Root Cause: {root_cause.upper()}")
        print(f"   Count: {count} failure(s)")
        print(f"\n   Example Error:")
        example_error = items[0].get('error', 'No error message')[:300]
        for line in example_error.split('\n')[:5]:
            print(f"   {line}")

        print(f"\n{fix}")
        print("\n" + "-" * 80)

        results.append((root_cause, count, fix))

    return results

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 self_heal_runner.py <test_results.json>")
        print("\nGenerate test results with:")
        print("  flutter test --machine > test_results.json")
        print("\nExample:")
        print("  cd apps/productivity/pomodoro_timer")
        print("  flutter test --machine > test_results.json")
        print("  python3 ../../../tools/self_heal_runner.py test_results.json")
        sys.exit(1)

    test_file = Path(sys.argv[1])
    if not test_file.exists():
        print(f"❌ Test results not found: {test_file}")
        sys.exit(1)

    failures = analyze_failures(str(test_file))

    if failures:
        print(f"\n\n⚠️ SUMMARY: {len(failures)} unique failure pattern(s) detected")
        print(f"   Total failures: {sum(count for _, count, _ in failures)}")
        print("\n📋 Next Steps:")
        print("   1. Review suggested fixes above")
        print("   2. Apply fixes to source code")
        print("   3. Re-run tests: flutter test")
        print("   4. Verify all tests pass")
        print("\n💡 Production Enhancement:")
        print("   - Integrate RAG for historical fix lookup")
        print("   - Auto-generate patches via LLM")
        print("   - Create sandbox branch and run tests")
        print("   - Auto-create PR if all tests pass")
        sys.exit(1)
    else:
        print("\n✅ ALL TESTS PASSED or no failures to analyze")
        sys.exit(0)
