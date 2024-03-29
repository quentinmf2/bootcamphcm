namespace: Integrations.demo.aos.Users
flow:
  name: create_user
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
            - db_server_name: 10.0.46.74
            - db_type: PostgreSQL
            - username: '${db_user}'
            - password:
                value: '${db_password}'
                sensitive: true
            - database_name: adv_account
            - command: "${\"INSERT INTO account (user_id, user_type, active, agree_to_receive_offers, defaultpaymentmethodid, email, internallastsuccesssullogin, internalunsuccessfulloginattempts, internaluserblockedfromloginuntil, login_name, password, country_id) VALUES (\"+user_id+\", 20, 'Y', true, 0, 'someone@microfocus.com', 0, 0, 0, '\"+created_name+\"', '\"+username_password_sha1+\"', 210);\"}"
            - trust_all_roots: 'true'
        navigate:
          - SUCCESS: Send_Message
          - FAILURE: on_failure
    - Send_Message:
        do_external:
          a1e51a2b-19e2-4444-9ad3-431430b39bfc:
            - url: '${mm_url}'
            - username: '${mm_user}'
            - password:
                value: '${mm_password}'
                sensitive: true
            - channel_id: '${mm_channel_id}'
            - message: "${'User '+created_name+' added to AOS at '+db_host}"
        navigate:
          - success: SUCCESS
          - failure: on_failure
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
      Send_Message:
        x: 659
        'y': 319
        navigate:
          aa36e778-a5e6-f7b8-e866-b60a980211e0:
            targetId: 67b253b7-ed9d-f6c1-3426-903ac8fd2170
            port: success
    results:
      SUCCESS:
        67b253b7-ed9d-f6c1-3426-903ac8fd2170:
          x: 796
          'y': 194
