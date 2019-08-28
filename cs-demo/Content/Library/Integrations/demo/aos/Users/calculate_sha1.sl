namespace: Integrations.demo.aos.Users
flow:
  name: calculate_sha1
  inputs:
    - host
    - user
    - password:
        sensitive: true
    - text
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${\"echo -n '\"+text+\"' | sha1sum | awk '{print $1}'\"}"
            - username: '${user}'
        publish:
          - sha1: '${return_result.strip()}'
        navigate:
          - FAILURE: on_failure
  outputs:
    - sha1: '${sha1}'
  results:
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 319
        'y': 222
