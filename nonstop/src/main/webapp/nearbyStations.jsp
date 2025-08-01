<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/ev_portal";
    String dbUser = "root";   // change if needed
    String dbPass = "root";   // change if needed
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(url, dbUser, dbPass);
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT station_name, address, latitude, longitude, slots_available FROM ev_stations");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nearby Charging Stations</title>
    <style>
        body { margin:0; font-family: Arial, sans-serif; }
        header { background: #333; color: #fff; padding: 10px 20px; }
        header h1 { margin: 0; font-size: 24px; }
        #map { width: 100%; height: 90vh; }
        .info { padding: 10px; text-align: center; background: #f1f1f1; }

        /* Floating Button */
        #showLocationBtn {
            position: absolute;
            bottom: 20px;
            right: 20px;
            z-index: 999;
            padding: 14px 16px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
            cursor: pointer;
        }
        #showLocationBtn:hover { background: #0056b3; }
    </style>

    <script>
        let map, userMarker, userCircle, userLocation;
        let stationMarkers = [];
        let pathLine = null;

        let stations = [
            <% while(rs.next()) { %>
            {
                name: "<%= rs.getString("station_name") %>",
                address: "<%= rs.getString("address") %>",
                lat: <%= rs.getDouble("latitude") %>,
                lng: <%= rs.getDouble("longitude") %>,
                slots: <%= rs.getInt("slots_available") %>
            },
            <% } %>
        ];

        function initMap() {
            const defaultLocation = { lat: 20.5937, lng: 78.9629 }; // India center
            map = new google.maps.Map(document.getElementById('map'), {
                center: defaultLocation,
                zoom: 5
            });

            if (navigator.geolocation) {
                // One-time location detection
                navigator.geolocation.getCurrentPosition(updateUserLocation, handleLocationError, { enableHighAccuracy: true });
                // Continuous update
                navigator.geolocation.watchPosition(updateUserLocation, handleLocationError, { enableHighAccuracy: true });
            } else {
                alert("Geolocation not supported");
                showStations();
            }
        }

        function updateUserLocation(position) {
            userLocation = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };

            if (!userMarker) {
                userMarker = new google.maps.Marker({
                    position: userLocation,
                    map,
                    title: "You are here",
                    icon: {
                        path: google.maps.SymbolPath.CIRCLE,
                        scale: 8,
                        fillColor: '#007bff',
                        fillOpacity: 1,
                        strokeWeight: 2,
                        strokeColor: 'white'
                    }
                });

                userCircle = new google.maps.Circle({
                    strokeColor: '#007bff',
                    strokeOpacity: 0,
                    strokeWeight: 0,
                    fillColor: '#007bff',
                    fillOpacity: 0.2,
                    map,
                    center: userLocation,
                    radius: 100
                });

                map.setCenter(userLocation);
                map.setZoom(15);
            } else {
                userMarker.setPosition(userLocation);
                userCircle.setCenter(userLocation);
            }

            showStations();
        }

        function handleLocationError(error) {
            alert("Location error: " + error.message);
            showStations();
        }

        function calculateDistance(lat1, lon1, lat2, lon2) {
            const R = 6371; // km
            const dLat = (lat2 - lat1) * Math.PI / 180;
            const dLon = (lon2 - lon1) * Math.PI / 180;
            const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                      Math.sin(dLon/2) * Math.sin(dLon/2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            return R * c;
        }

        function clearMarkers() {
            stationMarkers.forEach(marker => marker.setMap(null));
            stationMarkers = [];
            if (pathLine) pathLine.setMap(null);
        }

        function showStations() {
            if (!userLocation) return;
            clearMarkers();

            let nearestStation = null;
            let nearestDistance = Infinity;

            stations.forEach(station => {
                const distance = calculateDistance(userLocation.lat, userLocation.lng, station.lat, station.lng);
                if (distance < nearestDistance) {
                    nearestDistance = distance;
                    nearestStation = station;
                }

                const iconColor = (station.slots > 0)
                    ? "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
                    : "http://maps.google.com/mapfiles/ms/icons/red-dot.png";

                const marker = new google.maps.Marker({
                    position: {lat: station.lat, lng: station.lng},
                    map,
                    title: station.name,
                    icon: iconColor
                });
                stationMarkers.push(marker);

                const infowindow = new google.maps.InfoWindow({
                    content: `<b>${station.name}</b><br>${station.address}<br>` +
                             `<b>Slots: ${station.slots}</b><br>` +
                             `<b>Distance: ${distance.toFixed(2)} km</b>`
                });
                marker.addListener("click", () => infowindow.open(map, marker));
            });

            // Highlight nearest station
            if (nearestStation) {
                const eta = (nearestDistance / 40) * 60; // 40 km/h speed
                const nearestMarker = new google.maps.Marker({
                    position: {lat: nearestStation.lat, lng: nearestStation.lng},
                    map,
                    title: "Nearest Station: " + nearestStation.name,
                    icon: "http://maps.google.com/mapfiles/ms/icons/yellow-dot.png"
                });
                stationMarkers.push(nearestMarker);

                const nearestInfo = new google.maps.InfoWindow({
                    content: `<b>Nearest Station:</b><br>${nearestStation.name}<br>` +
                             `${nearestStation.address}<br>` +
                             `<b>Slots: ${nearestStation.slots}</b><br>` +
                             `<b>Distance: ${nearestDistance.toFixed(2)} km</b><br>` +
                             `<b>ETA: ${eta.toFixed(0)} min</b>`
                });
                nearestInfo.open(map, nearestMarker);

                pathLine = new google.maps.Polyline({
                    path: [userLocation, {lat: nearestStation.lat, lng: nearestStation.lng}],
                    geodesic: true,
                    strokeColor: "#FF0000",
                    strokeOpacity: 1.0,
                    strokeWeight: 2,
                    map: map
                });
            }
        }

        function centerOnUser() {
            if (userLocation) {
                map.setCenter(userLocation);
                map.setZoom(15);
            } else {
                alert("User location not available yet!");
            }
        }
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD_LWRkQHRmxIvqRRmTQi-Fv4TvJAZdiZ0&callback=initMap">
    </script>
</head>
<body>
    <header>
        <h1>Nearby Charging Stations</h1>
    </header>
    <div class="info">Blue = You, Green = Slots Available, Red = Full, Yellow = Nearest</div>
    <div id="map"></div>
    <button id="showLocationBtn" onclick="centerOnUser()">📍</button>
</body>
</html>
<%
    rs.close();
    stmt.close();
    conn.close();
%>
