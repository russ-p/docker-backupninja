````
                                          |\_
                 B A C K U P N I N J A   /()/
                                         `\|
                         
      a silent flower blossom death strike to lost data.
````

## Usage

````
	docker run --rm -it \
		-v `pwd`/config/:/etc/backup.d/ \
    	-v `pwd`/backups/:/backup \
		-e WHEN="everyday at 02:30" \
		-e REPORT_EMAIL=youremail@gmail.com \
		-e SMTP_SERVER=smtp.gmail.com \
		-e SMTP_PORT=587 \
		-e SMTP_USER_NAME=from.email@gmail.com \
		-e SMTP_PASSWORD=password \
		-e SMTP_ENABLE_STARTTLS=YES \
		<IMAGE_NAME> now
````

````
  backup:
    image: <IMAGE_NAME>
    restart: always
    environment:
      - WHEN=everyday at 03:00
      - REPORT_EMAIL=youremail@gmail.com
      - SMTP_SERVER=smtp.gmail.com
      - SMTP_USER_NAME=from.email@gmail.com
      - SMTP_PASSWORD=password
      - SMTP_PORT=587
      - SMTP_ENABLE_STARTTLS=YES 
    volumes:
      - /config/:/etc/backup.d/
      - /storage/backup:/backup
    command: run  
````
