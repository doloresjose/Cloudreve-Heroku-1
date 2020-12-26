FROM redis:alpine

RUN wget -qO /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk \
    && apk add --no-cache glibc-2.32-r0.apk \
    && rm -rf glibc-2.32-r0.apk

ADD run.sh /root/cloudreve/run.sh
ADD cloudreve.db /root/cloudreve/cloudreve.db
ADD aria2.conf /root/aria2/aria2.conf
ADD trackers-list-aria2.sh /root/aria2/trackers-list-aria2.sh

RUN apk add --update --no-cache aria2 && rm -rf /var/cache/apk/*

RUN wget -qO cloudreve.tar.gz https://github.com/FuaerCN/Cloudreve-Heroku/releases/download/Cloudreve/cloudreve_linux_amd64.tar.gz \
	&& tar -zxvf cloudreve.tar.gz -C /root/cloudreve \
	&& chmod +x /root/aria2/trackers-list-aria2.sh \
	&& chmod +x /root/cloudreve/cloudreve /root/cloudreve/run.sh
	
RUN touch /root/aria2/aria2.session /root/aria2/aria2.log	
RUN mkdir -p /root/Download

CMD /root/cloudreve/run.sh
