# HumidApp

OO대학교 전자공학과 공학설계과목에서 사용하기 위한 어플리케이션입니다.

이 어플리케이션은 온습도와 미세먼지 농도를 확인하는 스마트폰 어플리케이션에 해당합니다.

```plaintext
+-----------+   +-------+   +---------+
| App(this) +---+ Rails +---+ Arduino |
+-----------+   +-------+   +---------+
```

* API 서버는 [HumidAPI](https://github.com/Ch1keen/humidapi)에서 확인해주시기 바랍니다.

## Feature

* API 서버와 연동하여 온습도, 미세먼지 농도(PM 2.5, PM 10)를 볼 수 있음.

## 특징

`main.dart`는 단순히 `view/dashboard.dart`를 불러오는 역할에 지나지 않습니다.

## dashboard.dart

3초에 한번씩 192.168.126.97에 POST 요청을 전송합니다. 이 부분은 Stream과 yield를 이용하여 작성했습니다.

서버에 문제가 생기거나 네트워크 통신에 문제가 생길 경우 Stream이 중지가 되기 때문에, 필요한 경우 다시 Stream을 재개하기 위하여 setState()를 부를 수 있도록 작성했습니다.
