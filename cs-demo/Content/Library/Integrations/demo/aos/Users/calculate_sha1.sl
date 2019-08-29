namespace: Integrations.demo.aos.Users
flow:
  name: calculate_sha1
  inputs:
    - host: itom1.hcm.demo.local
    - user: root
    - password:
        default: S0lutions2016
        sensitive: true
    - text: cloud
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${\"echo -n '\"+text+\"' | sha1sum | awk '{print $1}'\"}"
            - username: '${user}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - sha1: '${return_result.strip()}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - sha1: '${sha1}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 370
        'y': 152
        navigate:
          7dbe8b8a-6f52-bf8d-80a1-62348a47b262:
            targetId: c1f693d7-df0d-1398-786e-6b1c1bb006f4
            port: SUCCESS
    results:
      SUCCESS:
        c1f693d7-df0d-1398-786e-6b1c1bb006f4:
          x: 478
          'y': 158
