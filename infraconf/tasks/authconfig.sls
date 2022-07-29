{% for config in [
  { 'pattern': '^USELDAPAUTH=yes$', 'repl': 'USELDAPAUTH=no' },
  { 'pattern': '^USELDAP=yes', 'repl': 'USELDAP=no' }
  ]
%}
Disable {{ config.pattern}} in authconfig:
  file.replace:
    - name: '/etc/sysconfig/authconfig'
    - pattern: {{ config.pattern }}
    - repl: {{ config.repl }}
{% endfor %}

