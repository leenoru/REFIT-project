let map = null;
let currentLatitude=0;
let currentLongitude=0;
let markers =[];
window.initMap = function () {
  navigator.geolocation.getCurrentPosition(function(position) {
    startLatitude = 37.46807840363115;
    startLongitude = 126.88559186602163;
    /* https 에서 navigator 사용 가능
    currentLatitude = position.coords.latitude;
    currentLongitude = position.coords.longitude;
    */
    initMap3(startLatitude, startLongitude);
    console.log(startLatitude, startLongitude);

    $.ajax({
      url: "/collection/search2",
      method: "GET",
      contentType: "application/json",
      success: function(response) {
        console.log("company 마커");
        var company_names = response.map(function(item) {
          return item.company_name;
        });

        for (var i = 0; i < response.length; i++) {
          (function(i) {
            var address = response[i].company_address;
            // 주소를 지오코딩하여 위도와 경도 얻기
            var geocoder = new google.maps.Geocoder();
            geocoder.geocode({ address: address }, function(results, status) {
              if (status === google.maps.GeocoderStatus.OK) {
                var latitude = results[0].geometry.location.lat();
                var longitude = results[0].geometry.location.lng();
                // createCompanyMarker 함수 실행
                createCompanyMarker(latitude, longitude, company_names[i], startLatitude, startLongitude);
              } else {
                console.log('지오코딩 실패: ' + status);
              }
            });
          })(i);
        }
      },
      error: function(error) {
        console.log("데이터를 가져오는 중 오류가 발생했습니다.");
        console.log(error);
      }
    });

    $.ajax({
      url: "/bins/address",
      method: "GET",
      contentType: "application/json",
      success: function(response) {
        const distances = [];
        const distances2 = [];
        for (let i = 0; i < Object.keys(response).length; i++) {
          const binLongitude = response[i].longitude;
          const binLatitude = response[i].latitude;
          const distance = calculateDistance(startLongitude, startLatitude, binLongitude, binLatitude);
          if (binLatitude > 0 && binLongitude > 0) {
            distances.push({ index: i, distance: distance });
            distances2.push({ index: i, distance: distance });
          }
        }

        distances.sort((a, b) => a.distance - b.distance);
        createStartMarker(startLatitude, startLongitude);

        for (let i = 0; i < 5; i++) {
          const index = distances[i].index;
          const binLongitude = response[index].longitude;
          const binLatitude = response[index].latitude;
          createMarker2(binLatitude, binLongitude);
        }
      },
      error: function(error) {
        console.log("주소 데이터를 가져오는 중 오류가 발생했습니다.");
        console.log(error);
      }
    });
  });
};


function initMap2(latitude, longitude) {
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: latitude, lng: longitude },
      zoom: 15
    });
}

function initMap3(latitude, longitude) {
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: latitude, lng: longitude },
      zoom: 15
    });
}
  function calculateDistance(lat1, lon1, lat2, lon2) {
    const radlat1 = Math.PI * lat1 / 180;
    const radlat2 = Math.PI * lat2 / 180;
    const theta = lon1 - lon2;
    const radtheta = Math.PI * theta / 180;
    let dist =
      Math.sin(radlat1) * Math.sin(radlat2) +
      Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    dist = Math.acos(dist);
    dist = dist * 180 / Math.PI;
    dist = dist * 60 * 1.1515;
    dist = dist * 1.609344; // km로 변환
    return dist.toFixed(2); // 소수점 2자리까지 제한
  }
// Marker 생성
function createMarker(latitude, longitude) {
  var marker = new google.maps.Marker({
    position: {lat: parseFloat(latitude), lng: parseFloat(longitude)},
    map: map
  });
  markers.push(marker);
  map.setZoom(15);

  // 마커 클릭 이벤트 처리
  marker.addListener('click', function() {
    openDirections(marker.getPosition());
  });
}
function createStartMarker(latitude, longitude) {
  var marker = new google.maps.Marker({
    position: {lat: parseFloat(latitude), lng: parseFloat(longitude)},
    map: map,
    icon: {
        url: '/resources/image/marker/pngwing.com.png',
        scaledSize: new google.maps.Size(30, 50) // 마커의 크기를 조정
      }
  });
  markers.push(marker);
  map.setZoom(15);
}

function createCompanyMarker(latitude, longitude, companyName, startLatitude, startLongitude) {
    var marker = new google.maps.Marker({
        position: {lat: parseFloat(latitude), lng: parseFloat(longitude)},
        map: map,
        icon: {
            url: '/resources/image/marker/company_marker.png',
            scaledSize: new google.maps.Size(30, 50)
        },
        title: companyName
    });
    markers.push(marker);
    map.setZoom(15);
}


function openDirections(destination) {
  const address = document.getElementById('searchBox').value;
  const geocoder = new google.maps.Geocoder();
  geocoder.geocode({ 'address': address }, function(results, status) {
    if (status === 'OK') {
      if (results[0]) {
        const origin = results[0].geometry.location.lat() + ',' + results[0].geometry.location.lng();
        const url = 'https://www.google.com/maps/dir/?api=1&origin=' + origin +
                    '&destination=' + destination.lat() + ',' + destination.lng();
        window.open(url);
      } else {
        console.log('해당 주소에 대한 결과를 찾을 수 없습니다.');
      }
    } else {
      console.log('Geocode 실패: ' + status);
    }
  });
}
function createMarker2(binLatitude, binLongitude) {
  var marker = new google.maps.Marker({
    position: { lat: parseFloat(binLatitude), lng: parseFloat(binLongitude) },
    map: map
  });
  markers.push(marker);

  // 센터를 startLatitude와 startLongitude로 이동
  map.setCenter(new google.maps.LatLng(startLatitude, startLongitude));
  map.setZoom(15);

  // 마커 클릭 이벤트 처리
  marker.addListener('click', function() {
    openDirection2(binLatitude, binLongitude);
  });
}

  function openDirection2(binLatitude, binLongitude) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        const latitude = position.coords.latitude;
        const longitude = position.coords.longitude;
        const url = 'https://www.google.com/maps/dir/?api=1&origin=' + latitude + ',' + longitude +
                    '&destination=' + binLatitude + ',' + binLongitude;
        window.open(url);
      }, function(error) {
        console.log('위치 정보를 가져오는 중 오류가 발생했습니다.');
        console.log(error);
      });
    } else {
      console.log('Geolocation을 지원하지 않습니다.');
    }
  }

function searchBins() {

const address = document.getElementById('searchBox').value;
const geocoder = new google.maps.Geocoder();
geocoder.geocode({ 'address': address }, function(results, status) {
  if (status === 'OK') {
    if (results[0]) {

      const latitude = results[0].geometry.location.lat();
      const longitude = results[0].geometry.location.lng();
      initMap2(latitude, longitude);
      $.ajax({
        url: "/bins/address",
        method: "GET",
        contentType: "application/json",
        success: function(response) {
            const distances = [];

          for (let i = 0; i < Object.keys(response).length; i++) {
            const binLongitude = response[i].longitude;
            const binLatitude = response[i].latitude;
            const distance = calculateDistance(longitude, latitude, binLongitude, binLatitude);
            distances.push({ index: i, distance: distance });
          }

          distances.sort((a, b) => a.distance - b.distance);
          createStartMarker(latitude, longitude);
          for (let i = 0; i < 5; i++) {
            const index = distances[i].index;
            const binLongitude = response[index].longitude;
            const binLatitude = response[index].latitude;
            console.log('경도: ' + binLongitude + ', 위도: ' + binLatitude);
            createMarker(binLatitude, binLongitude);
          }
        },
        error: function(error) {
          console.log("주소 데이터를 가져오는 중 오류가 발생했습니다.");
          console.log(error);
        }
      });
    $.ajax({
        url: "/collection/search2",
        method: "GET",
        contentType: "application/json",
        success: function(response) {
            console.log(response);
            for (var i = 0; i < response.length; i++) {
                var company_name = response[i].company_name; // company_name 가져오기
                var address = response[i].company_address;
                // 주소를 지오코딩하여 위도와 경도 얻기
                var geocoder = new google.maps.Geocoder();

                geocoder.geocode({ address: address }, function(results, status) {
                    if (status === google.maps.GeocoderStatus.OK) {
                        var latitude = results[0].geometry.location.lat();
                        var longitude = results[0].geometry.location.lng();
                        // createMarker 함수 실행
                        createCompanyMarker(latitude, longitude, company_name, latitude, longitude);
                    } else {
                        console.log('지오코딩 실패: ' + status);
                    }
                });
            }
          },
          error: function(error) {
            console.log("주소 데이터를 가져오는 중 오류가 발생했습니다.");
            console.log(error);
          }
        });
    } else {
      console.log('해당 주소에 대한 결과를 찾을 수 없습니다.');
    }
  } else {
    console.log('Geocode 실패: ' + status);
  }
});
}


