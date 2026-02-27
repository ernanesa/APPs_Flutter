#!/usr/bin/env python3
"""Generate APP_PUBLICATION_STATUS.md by scanning apps/ and parsing publishing checklists.
"""
import os
import re
from datetime import datetime

ROOT = os.path.dirname(os.path.dirname(__file__))
APPS_DIR = os.path.join(ROOT, 'apps')
OUTPUT = os.path.join(ROOT, 'APP_PUBLICATION_STATUS.md')
RANK_FILE = os.path.join(ROOT, 'APPS_RANKED_BY_COMPLETION.md')

# Helper to read small file safely

def read_file(path):
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception:
        return ''


def find_version_and_date(text):
    version = ''
    date = ''
    # search for lines like: **Versão:** 1.0.0+1 or **Version:**
    m = re.search(r'Vers(?:ão|ion):\s*([0-9]+(?:\.[0-9]+)*(?:\+[0-9]+)?)', text, re.IGNORECASE)
    if m:
        version = m.group(1)
    m2 = re.search(r'\bData:\s*([0-9]{1,2}\s+de\s+\w+\s+de\s+[0-9]{4}|[0-9]{2}/[0-9]{2}/[0-9]{4})', text, re.IGNORECASE)
    if m2:
        date = m2.group(1)
    return version, date


# Parse publishing column from APPS_RANKED_BY_COMPLETION.md for 'publishing' status
publishing_map = {}
rank_text = read_file(RANK_FILE)
if rank_text:
    # crude table parsing: lines with | index | app | ... | publishing | android |
    lines = rank_text.splitlines()
    for line in lines:
        if line.startswith('|') and '|' in line:
            cols = [c.strip() for c in line.split('|')][1:-1]
            if len(cols) >= 11:
                app = cols[1]
                publishing = cols[9]
                publishing_map[app] = '✅' in publishing


rows = []
for cluster in sorted(os.listdir(APPS_DIR)):
    cluster_dir = os.path.join(APPS_DIR, cluster)
    if not os.path.isdir(cluster_dir):
        continue
    for app in sorted(os.listdir(cluster_dir)):
        app_dir = os.path.join(cluster_dir, app)
        if not os.path.isdir(app_dir):
            continue
        # default values
        ready = False
        ready_date = ''
        published = False
        published_date = ''
        version = ''
        notes = []
        # Check APPS_RANKED map
        if app in publishing_map:
            ready = publishing_map.get(app, False)
            if ready:
                notes.append('Publishing flag from APPS_RANKED_BY_COMPLETION')
        # Look for publishing checklist files
        pub_md = os.path.join(app_dir, 'publishing', 'CHECKLIST_CONCLUIDO.md')
        if os.path.exists(pub_md):
            text = read_file(pub_md)
            v, d = find_version_and_date(text)
            if v:
                version = v
            if d:
                ready_date = d
            # check for AAB presence note
            if 'aab' in text.lower() or 'app-release.aab' in text:
                notes.append('AAB generated')
                ready = True
        # Quality report or publication master
        q_md = os.path.join(app_dir, 'publishing', 'QUALITY_REPORT.md')
        if os.path.exists(q_md):
            text = read_file(q_md)
            v, d = find_version_and_date(text)
            if v and not version:
                version = v
            if 'PAra Publicação' in text or 'Pronto para Publicação' in text or 'APROVADO' in text.upper():
                ready = True
                notes.append('Quality report: ready for publication')
            # date
            m = re.search(r'\*\*Data:\*\*\s*([0-9]{1,2}\s+de\s+\w+\s+de\s+[0-9]{4}|[0-9]{2}/[0-9]{2}/[0-9]{4})', text)
            if m:
                ready_date = ready_date or m.group(1)
        pub_master = os.path.join(app_dir, 'publishing', 'PUBLICATION_MASTER.md')
        if os.path.exists(pub_master):
            text = read_file(pub_master)
            v, d = find_version_and_date(text)
            if v and not version:
                version = v
        # Check for explicit "LIVE" markers in implementation reports
        impl = read_file(os.path.join(ROOT, 'IMPLEMENTATION_REPORT_7_APPS.md'))
        if app in impl and 'READY FOR PUBLICATION' in impl:
            if 'READY FOR PUBLICATION' in impl:
                ready = True
        # Published detection: only mark published if explicit marker exists in app publishing folder
        published = False
        pub_marker = os.path.join(app_dir, 'publishing', 'PUBLISHED_ON_PLAYSTORE.md')
        if os.path.exists(pub_marker):
            published = True
            marker_text = read_file(pub_marker)
            m = re.search(r'\bDate:\s*([0-9]{1,2}\s+de\s+\w+\s+de\s+[0-9]{4}|[0-9]{2}/[0-9]{2}/[0-9]{4})', marker_text)
            if m:
                published_date = m.group(1)
            notes.append('Published marker found')
        # final notes string
        notes_str = '; '.join(notes) if notes else ''
        rows.append((app, cluster, 'Yes' if ready else 'No', ready_date or '-', 'Yes' if published else 'No', published_date or '-', version or '-', notes_str))

# Sort rows by app name
rows.sort()

# Write output markdown
now = datetime.utcnow().strftime('%Y-%m-%d %H:%M UTC')
with open(OUTPUT, 'w', encoding='utf-8') as f:
    f.write('# App Publication Status\n')
    f.write(f'**Gerado:** {now}\n\n')
    f.write('| App | Cluster | Ready for Publication | Ready Date | Published | Published Date | Version | Notes |\n')
    f.write('|-----|---------|:--------------------:|:----------:|:---------:|:---------------:|:-------:|------|\n')
    for r in rows:
        f.write(f'| {r[0]} | {r[1]} | {r[2]} | {r[3]} | {r[4]} | {r[5]} | {r[6]} | {r[7]} |\n')

print('Generated', OUTPUT)
