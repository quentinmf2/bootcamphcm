namespace: Integrations.demo.aos.Users
flow:
  name: create_user_1
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - credentials: quentin=cloud
    - file_path: /tmp/users.txt
    - db_host: 10.0.46.74
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
    - parse_credentials:
        do:
          Integrations.demo.aos.Users.parse_credentials:
            - credentials: '${credentials}'
        publish:
          - created_name: '${name}'
          - create_password: '${password}'
        navigate:
          - SUCCESS: calculate_sha1
    - calculate_sha1:
        do:
          Integrations.demo.aos.Users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
            - text: '${create_password}'
        publish:
          - password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: calculate_sha1_1
    - calculate_sha1_1:
        do:
          Integrations.demo.aos.Users.calculate_sha1:
            - host: '${file_host}'
            - user: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
            - text: '${created_name[::-1]+password_sha1}'
        publish:
          - username_password_sha1: '${sha1}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: random_number_generator
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '100000000'
            - max: '1000000000'
        publish:
          - user_id: '${random_number}'
        navigate:
          - SUCCESS: sql_command
          - FAILURE: on_failure
    - sql_command:
        do:
          io.cloudslang.base.database.sql_command:
            - db_server_name: '${db_host}'
            - db_type: PostgreSQL
            - username: '${db_user}'
            - password:
                value: '${db_password}'
                sensitive: true
            - database_name: adv_account
            - command: "${\"INSERT INTO account (user_id, user_type, active, agree_to_receive_offers, defaultpaymentmethodid, email, internallastsuccesssullogin, internalunsuccessfulloginattempts, internaluserblockedfromloginuntil, login_name, password, country_id) VALUES (\"+user_id+\", 20, 'Y', true, 0, 'someone@microfocus.com', 0, 0, 0, '\"+created_name+\"', '\"+username_password_sha1+\"', 210);\"}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      parse_credentials:
        x: 283
        'y': 176
      calculate_sha1:
        x: 275
        'y': 341
      calculate_sha1_1:
        x: 462
        'y': 339
      random_number_generator:
        x: 467
        'y': 174
      sql_command:
        x: 683
        'y': 184
        navigate:
          bcd18f35-a1d1-fa55-fc85-32e8937fec05:
            targetId: 67b253b7-ed9d-f6c1-3426-903ac8fd2170
            port: SUCCESS
    results:
      SUCCESS:
        67b253b7-ed9d-f6c1-3426-903ac8fd2170:
          x: 796
          'y': 194
