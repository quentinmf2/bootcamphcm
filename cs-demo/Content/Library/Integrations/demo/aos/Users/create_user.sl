namespace: Integrations.demo.aos.Users
flow:
  name: create_user
  inputs:
    - file_host
    - file_user
    - file_password:
        sensitive: true
    - credentials
    - db_host
    - db_password:
        sensitive: true
    - db_user
    - mm_url
    - mm_user
    - mm_password:
        sensitive: true
    - mm_channel_id
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command: []
        navigate:
          - FAILURE: on_failure
  results:
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 339
        'y': 214
