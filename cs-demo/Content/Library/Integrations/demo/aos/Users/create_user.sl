namespace: Integrations.demo.aos.Users
flow:
  name: create_user
  inputs:
    - file_host: itom1.hcm.demo.local
    - file_user: root
    - file_password:
        default: S0lutions2016
        sensitive: true
    - credentials
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
 
  results: []
