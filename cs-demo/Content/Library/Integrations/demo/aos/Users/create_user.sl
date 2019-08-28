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
    - db_user
    - db_password:
        sensitive: true
    - mm_url
    - mm_user
    - mm_password
        sensitive: true
    - mm_channel_id 
  results: []
