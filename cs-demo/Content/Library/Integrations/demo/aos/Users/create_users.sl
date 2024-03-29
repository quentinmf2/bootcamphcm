namespace: Integrations.demo.aos.Users
flow:
  name: create_users
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - file_path: /tmp/users.txt
    - db_host: AOS VM
    - db_user: postgres
    - db_password:
        default: admin
        sensitive: true
    - mm_url: 'https://mattermost.hcm.demo.local'
    - mm_user: admin
    - mm_password:
        default: Cloud_123
        sensitive: true
    - mm_channel_id: eeujbpz9ufbc8rxcyj9qhcgq3a
  workflow:
    - read_users:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${file_host}'
            - command: "${'cat '+file_path}"
            - username: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
        publish:
          - file_content: '${return_result}'
        navigate:
          - SUCCESS: create_user
          - FAILURE: on_failure
    - create_user:
        loop:
          for: credentials in file_content.split()
          do:
            Integrations.demo.aos.Users.create_user:
              - credentials: '${credentials}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      read_users:
        x: 369
        'y': 75
      create_user:
        x: 309
        'y': 226
        navigate:
          9af4e04d-e611-ea9d-93ed-03604ec7f654:
            targetId: 69a34338-ce36-ff96-677f-8105308cf224
            port: SUCCESS
    results:
      SUCCESS:
        69a34338-ce36-ff96-677f-8105308cf224:
          x: 613
          'y': 254
