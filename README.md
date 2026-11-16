# Solo Traveller Planner ✈️

A Flutter-based Solo Traveller Planner that helps users plan trips with minimal manual input. Enter your source city, destination city, travel dates, and travel style to get an estimated trip budget, destination weather forecast, and quick access to external travel services.

## ✨ Features

- **Smart Trip Planning:** Enter source, destination, travel dates, and travel style.
- **Distance Calculation:** Automatically calculate driving distance between source and destination.
- **Budget Estimation:** Get an approximate budget divided into Travel, Stay, Food, and Local Transport.
- **Travel Styles:** Choose between Budget, Standard, and Comfort.
- **Weather Forecast:** View destination weather information using Open-Meteo.
- **Google Maps:** Open the destination in Google Maps.
- **Flight & Train Search:** Open external travel platforms with source and destination pre-filled.
- **Hotel Search:** Search for accommodation using the destination and travel dates.
- **Trip Sharing:** Share trip details using the system share sheet.
- **Saved Trips:** Save generated trip plans locally using SQLite and view them later.
- **Offline History:** View previously saved trip information without making unnecessary network requests.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Programming language |
| BLoC | State management |
| Clean Architecture | Separation of concerns |
| Dio | REST API communication |
| SQLite (sqflite) | Local trip persistence |
| Open-Meteo Geocoding | City name to coordinates |
| OSRM | Driving route distance |
| Open-Meteo Forecast | Weather information |
| URL Launcher | External application integration |
| Share Plus | System share sheet |

## 🏗️ Architecture

The application follows Clean Architecture with feature-based organization.

```text
lib/
├── core/
│   ├── constants/
│   ├── database/
│   ├── di/
│   ├── enums/
│   ├── error/
│   ├── extensions/
│   ├── theme/
│   ├── utility/
│   └── widgets/
│
├── feature/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── detail/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── history/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

### Architectural Layers

- **Presentation:** Screens, reusable widgets, BLoC events, and states.
- **Domain:** Business entities, repository contracts, and use cases.
- **Data:** Remote/local data sources, models, and repository implementations.
- **Core:** Shared application infrastructure, database, constants, error handling, and dependency injection.

## 🌐 APIs & External Services

All external APIs used in this project are public and do not require API keys or secret tokens. The application can access these services without additional API credential configuration.

### 1. Open-Meteo Geocoding API

Used to convert source and destination city names into geographical coordinates.

- **Endpoint:** `GET https://geocoding-api.open-meteo.com/v1/search`

**Query Parameters:**

| Parameter | Type | Value / Description |
|---|---|---|
| `name` | String | Sanitized city name (e.g. Chennai) |
| `count` | int | `1` – Best matching location |
| `language` | String | `en` |
| `format` | String | `json` |

**Data Source:** `TripGeocodingRemoteDataSourceImpl`

Location: `lib/feature/home/data/datasources/`

### 2. OSRM – Open Source Routing Machine

Used to determine driving road distance between source and destination coordinates.

- **Endpoint:**

```text
GET https://router.project-osrm.org/route/v1/driving/{fromLongitude},{fromLatitude};{toLongitude},{toLatitude}?overview=false
```

**Query Parameters:**

| Parameter | Type | Value / Description |
|---|---|---|
| `overview` | String | `false` – Omits detailed route geometry |

**Distance Calculation:**

The API returns the one-way driving distance in metres. The application converts it into kilometres and doubles it to estimate a round trip.

**Data Source:** `RouteRemoteDataSourceImpl`

Location: `lib/feature/detail/data/datasources/`

### 3. Open-Meteo Weather Forecast API

Used to retrieve destination weather conditions and daily forecasts for the selected travel dates.

- **Endpoint:** `GET https://api.open-meteo.com/v1/forecast`

**Query Parameters:**

| Parameter | Type | Value / Description |
|---|---|---|
| `latitude` | double | Destination latitude |
| `longitude` | double | Destination longitude |
| `current` | String | `temperature_2m,relative_humidity_2m,weather_code` |
| `daily` | String | `weather_code,temperature_2m_max,temperature_2m_min` |
| `timezone` | String | `Asia/Kolkata` |
| `start_date` | String | Trip start date (`YYYY-MM-DD`) |
| `end_date` | String | Trip end date (`YYYY-MM-DD`) |

**Forecast Constraint:**

The date picker restricts itinerary duration to a maximum of 15 calendar days. Forecast availability is also subject to Open-Meteo's forecast horizon.

**WMO Weather Code Mapping:**

The application uses `WeatherCodeHelper` to convert standard WMO weather codes into user-friendly weather descriptions and icons.

**Data Source:** `WeatherRemoteDataSourceImpl`

Location: `lib/feature/detail/data/datasources/`

### 4. External Deep Links & Integrations

External services are launched using `url_launcher`, while trip details are shared using `share_plus`.

| Service | URL / Integration | Behavior |
|---|---|---|
| Google Maps | `https://www.google.com/maps/search/?api=1&query={destination}` | Opens the destination in Google Maps |
| Flights | Google Travel Flights URL | Pre-fills source, destination, and travel dates |
| Trains | External train search integration, if configured | Opens the relevant train search |
| Hotels | Google Travel Hotels URL | Pre-fills destination and stay dates |
| Share Sheet | Native system share using `share_plus` | Shares itinerary, budget breakdown, and forecast |

**Flight Search URL Format:**

```text
https://www.google.com/travel/flights?q=flights+to+{destination}+from+{from}+on+{start}+through+{end}
```

**Hotel Search URL Format:**

```text
https://www.google.com/travel/hotels?q=hotels+in+{destination}+on+{start}+through+{end}
```

The application uses external search links rather than fetching live flight, train, or hotel prices.

### 5. Network & Error Handling

- **Dio Client:** Configured with request timeouts and custom error mapping through `DioExtension`.
- **Clean Architecture Failures:** HTTP and format errors are mapped to strongly typed failures.
- **Failure Types:** `ServerFailure`, `LocationNotFoundFailure`, `NetworkFailure`, `ConnectionTimeoutFailure`, and `NoInternetFailure`.
- **Offline / Local Cache Mode:** When viewing previously saved trips with `useLocalData: true`, the application skips remote requests and loads persisted budget and weather information from SQLite.

## 💰 Budget Estimation Logic

The application calculates an approximate trip budget using the following inputs:

1. Distance between source and destination.
2. Number of travel days.
3. Number of hotel nights.
4. Selected travel style.

The estimated budget is divided into four categories.

### 1. Base Cost Configuration

| Category | Base Rate | Calculation |
|---|---:|---|
| Travel | ₹10 | Per kilometre |
| Hotel | ₹800 | Per night |
| Food | ₹800 | Per day |
| Local Transport | ₹1,000 | Per day |

These are predefined estimation values, not live market prices.

### 2. Travel Style Multipliers

| Travel Style | Multiplier |
|---|---:|
| Budget | 1.0x |
| Standard | 1.25x |
| Comfort | 1.5x |

- Budget uses the base estimated cost.
- Standard increases the estimated cost by 25%.
- Comfort increases the estimated cost by 50%.

The selected multiplier applies to all four budget categories.

### 3. Date Calculation

The trip duration is calculated using the selected start and end dates.

```dart
final start = DateTime(
  startDate.year,
  startDate.month,
  startDate.day,
);

final end = DateTime(
  endDate.year,
  endDate.month,
  endDate.day,
);

final diffDays = end.difference(start).inDays;

final totalTripDays = diffDays + 1;
final totalHotelNights = diffDays;
```

- Trip days include both the starting and ending dates.
- Hotel nights represent the difference between the two dates.

For example, a trip from November 18 to November 20 has:
- 3 travel days.
- 2 hotel nights.

### 4. Distance Calculation

The route distance is obtained from OSRM using the source and destination coordinates.

The one-way distance is converted from metres to kilometres, and a round trip is assumed.

```dart
final roundTripKm = (rawDistance / 1000) * 2;
```

### 5. Category-Wise Budget Calculation

**Travel Cost**

```text
Round Trip Distance × ₹10 × Travel Style Multiplier
```

**Hotel Cost**

```text
Hotel Nights × ₹800 × Travel Style Multiplier
```

**Food Cost**

```text
Trip Days × ₹800 × Travel Style Multiplier
```

**Local Transport Cost**

```text
Trip Days × ₹1,000 × Travel Style Multiplier
```

**Total Estimated Budget**

```text
Travel Cost
+ Hotel Cost
+ Food Cost
+ Local Transport Cost
```

### 6. Example Calculation

Consider the following trip:

| Input | Value |
|---|---|
| Source | Chennai |
| Destination | Bengaluru |
| One-way distance (example) | 350 km |
| Trip duration | 3 days |
| Hotel nights | 2 |
| Travel style | Standard |

Standard multiplier = 1.25x.

| Category | Calculation | Estimated Cost |
|---|---|---:|
| Travel | 700 × 10 × 1.25 | ₹8,750 |
| Hotel | 2 × 800 × 1.25 | ₹2,000 |
| Food | 3 × 800 × 1.25 | ₹3,000 |
| Local Transport | 3 × 1,000 × 1.25 | ₹3,750 |
| **Total** | | **₹17,500** |

*The distance is illustrative. Actual estimates depend on the route returned by OSRM.*

### Budget Estimation Assumptions

- Travel cost assumes a round trip using the same route distance.
- Travel cost is estimated using a fixed per-kilometre rate.
- Hotel cost is calculated based on the number of nights.
- Food and local transport are calculated per calendar travel day.
- Travel style applies a multiplier to all four categories.
- The estimates are indicative and are not real-time flight, train, hotel, or restaurant prices.
- Actual expenses may vary depending on availability, season, transportation mode, and personal preferences.

## 🌦️ Weather Integration

The application uses Open-Meteo to retrieve weather information for the destination.

Weather data is requested using the destination's geographical coordinates.

Information displayed includes:
- Current temperature.
- Relative humidity.
- Weather conditions.
- Daily minimum and maximum temperatures.
- Forecast for the selected travel dates, subject to API availability.

API: https://open-meteo.com/

## 💾 Local Persistence

SQLite is used to store generated trip plans locally.

Saved information includes trip details and the calculated information required to display previously generated plans.

The application provides:
- Save trip plans.
- Retrieve all saved trips.
- Retrieve a specific trip by ID.
- View recent searches.
- Access saved trip information without fetching remote data again.

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android emulator or physical Android device

### Clone the Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

```bash
cd solo_traveller_planner
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

### Build APK

```bash
flutter build apk --release
```

Generated APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Application Workflow

1. Enter the source and destination cities.
2. Select the travel start and end dates.
3. Choose Budget, Standard, or Comfort.
4. Generate the trip plan.
5. View route distance, estimated budget, and destination weather.
6. Open external travel services for maps, flights/trains, and hotels.
7. Share the trip plan or save it locally.
8. Access previously saved trips from trip history.

## ⚠️ Limitations

- Budget values are estimates based on predefined rates.
- Travel cost assumes a round trip by road.
- Flight and train prices are not fetched directly.
- Hotel prices are not fetched directly.
- External search results depend on the selected platform.
- Weather forecast availability depends on the external API's forecast horizon.
- OSRM public routing service availability and usage policies apply.
- An internet connection is required for remote API functionality.

## 👨‍💻 Developer
**Project:** Solo Traveller Planner  
**Framework:** Flutter  
**Architecture:** Clean Architecture  
**State Management:** BLoC  

**Name:** Saravanan v  
**Mail:** v.saravanan.c@gmail.com.  
