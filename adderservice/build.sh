#!/bin/bash
source ~/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
 container)
   sudo -u adrian docker build -t adderservice:$GITSHA .
   sudo -u adrian docker tag adderservice:$GITSHA \
     ytchan17/adderservice:$GITSHA
   sudo -i -u adrian docker push \
     ytchan17/adderservice:$GITSHA
 ;;
 deploy)
   sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ \
     < ../deployment/service-template.yml > svc.yml
   sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ \
     -e s/_IMAGE_/ytchan17\\/adderservice:$GITSHA/ \
     < ../deployment/deployment-template.yml > dep.yml
   sudo -i -u ytchan17 kubectl apply -f $(pwd)/svc.yml
   sudo -i -u ytchan17 kubectl apply -f $(pwd)/dep.yml
 ;;
 *)
   echo invalid build step
   exit 1
 ;;
esac
