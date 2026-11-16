# Budget Calculation Logic

The application calculates an approximate trip budget based on the distance between cities, travel duration, and selected travel style.

## Base Cost Configuration

| Category | Base Cost |
|---|---:|
| Travel | ₹10 per km |
| Hotel | ₹800 per night |
| Food | ₹800 per day |
| Local Transport | ₹1,000 per day |

## Travel Style Multipliers

| Travel Style | Multiplier |
|---|---:|
| Budget | 1.0x |
| Standard | 1.25x |
| Comfort | 1.5x |

## Calculation Method

**1. Trip Duration**

- Total days = (End Date - Start Date) + 1
- Hotel nights = End Date - Start Date

**2. Travel Distance**

The route distance is converted from metres to kilometres. A round trip is assumed.

```dart
roundTripKm = (distanceInMeters / 1000) * 2;
```

**3. Category-wise Cost**

```text
Travel Cost        = Round Trip KM × ₹10 × Multiplier
Hotel Cost         = Hotel Nights × ₹800 × Multiplier
Food Cost          = Total Days × ₹800 × Multiplier
Local Transport    = Total Days × ₹1,000 × Multiplier
```

**4. Total Estimated Budget**

```text
Total Budget = Travel Cost
             + Hotel Cost
             + Food Cost
             + Local Transport
```

## Example

Assume:
- One-way distance: 350 km
- Trip duration: 3 days
- Hotel nights: 2
- Travel style: Standard (1.25x)

| Category | Estimated Cost |
|---|---:|
| Travel | ₹8,750 |
| Hotel | ₹2,000 |
| Food | ₹3,000 |
| Local Transport | ₹3,750 |
| **Total** | **₹17,500** |

## Assumptions

- Travel cost assumes a round trip.
- Hotel cost is calculated per night.
- Food and local transport are calculated per day.
- Travel style multipliers are applied to all categories.
- All amounts are approximate estimates, not actual booking prices.
- Actual expenses may vary depending on transportation, accommodation, and personal preferences.