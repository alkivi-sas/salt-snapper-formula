# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "snapper/map.jinja" import snapper with context %}

snapper-pkg:
  pkg.installed:
    - name: {{ snapper.pkg }}
