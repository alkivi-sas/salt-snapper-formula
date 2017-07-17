# -*- coding: utf-8 -*-
# vim: ft=sls
include:
  - snapper

{% from "snapper/map.jinja" import snapper with context %}

{{ snapper.configs_dir }}:
  file.directory:
    - mode: 755
    - user: root
    - group: root
    - makedirs: True

{{ snapper.filters_dir }}:
  file.directory:
    - mode: 755
    - user: root
    - group: root
    - makedirs: True


{% for config_name, config_data in snapper.configs.items() %}
init_{{ config_name }}:
  cmd.run:
    - name: snapper -c {{ config_name }} create-config {{ config_data.get('subvolume') }}
    - creates: {{ snapper.configs_dir }}/{{ config_name }}
    - require:
      - file: {{ snapper.configs_dir }}
      - pkg: snapper-pkg

{{ snapper.configs_dir }}/{{ config_name }}:
  file.managed:
    - source: salt://snapper/templates/config.jinja
    - template: jinja
    - mode: 640
    - user: root
    - group: root
    - context:
      config: {{ config_data }}
    - require:
      - file: {{ snapper.configs_dir }}
{% endfor %}

{{ snapper.default }}:
  file.managed:
    - source: salt://snapper/templates/default.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root

{{ snapper.cron.script }}:
  file.managed:
    - source: salt://snapper/files/cron.sh
    - user: root
    - group: root
    - mode: 755

snapper-cron:
  cron.present:
    - name: {{ snapper.cron.script }}
    - identifier: Snapper Automatic Script
    - user: root
    - minute: '{{ snapper.cron.minute }}'
    - hour: '{{ snapper.cron.hour }}'
    - daymonth: '{{ snapper.cron.daymonth }}'
    - month: '{{ snapper.cron.month }}'
    - dayweek: '{{ snapper.cron.dayweek }}'
