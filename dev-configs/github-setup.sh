#!/bin/bash
# [ssh 키 생성 및 등록 방법](https://dev-district.tistory.com/17)
# [github에 GPG키 등록하기](https://velog.io/@peeeeeter_j/GitHub%EC%97%90-GPG-key-%EB%93%B1%EB%A1%9D%ED%95%98%EA%B8%B0)
# [github pat 발급 및 git 연동 방법](https://blueberryyum.tistory.com/26)
# [github token 인증](https://velog.io/@jini_eun/Github-2021%EB%85%84-8%EC%9B%94-13%EC%9D%BC%EB%B6%80%ED%84%B0-%ED%86%A0%ED%81%B0-%EC%9D%B8%EC%A6%9D-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EB%B3%80%ED%99%94)

ssh-keygen -t rsa -b 4096 -C "tromberx@gmail.com"
pbcopy <~/.ssh/id_rsa.pub

ssh-keygen -t id_ed25519 -C "tromberx@gmail.com"
pbcopy <~/.ssh/id_ed25519.pub
