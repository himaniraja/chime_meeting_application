# Chime Meeting App

A production-ready Flutter video meeting application using AWS Chime SDK for real-time video/audio calls.

## Features

### Implemented
- **Role-based Meeting Flow**
  - Agent: Creates meetings and hosts video calls
  - Client: Joins existing meetings as a participant

- **Multiple Join Methods**
  - QR Code scanning (mobile_scanner)
  - Copy/paste meeting data (JSON)
  - Deep link support (`himani://join?data=...`)

- **Video/Audio Call**
  - Real-time video using flutter_aws_chime SDK
  - Mute/unmute audio controls
  - Toggle camera on/off
  - Audio device selection (speaker/headphones)
  - Screen rotation support

- **Meeting Data Sharing**
  - QR code generation (qr_flutter) on Waiting screen
  - Copy meeting data to clipboard
  - Copy meeting ID

- **Permissions**
  - Camera permission handling
  - Microphone permission handling
  - Permission status display during calls

- **Clean Architecture**
  - Data layer: Models, DataSources, Repositories
  - Domain layer: Entities, UseCases, Repository interfaces
  - Presentation layer: BLoC, Screens, Widgets

- **State Management**
  - flutter_bloc for state management
  - Dependency injection with get_it

## Architecture

```
lib/
├── core/
│   ├── constants/       # App constants
│   ├── theme/            # App theme
│   └── errors/           # Failures & exceptions
├── data/
│   ├── models/           # Data models
│   ├── datasources/      # Remote data sources
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/       # Business logic
├── presentation/
│   ├── blocs/          # BLoC state management
│   ├── screens/        # UI screens
│   └── widgets/        # Reusable widgets
├── plugins/
│   └── flutter_aws_chime/  # AWS Chime SDK integration
└── di/                 # Dependency injection
```

## API Endpoints

The app uses 3 API endpoints (requires `x-api-key` header):

1. **Create Meeting (Agent)**
   ```
   POST /api/meetings?type=agent
   ```

2. **Join as Client**
   ```
   POST /api/meetings?type=client&meeting_id=<MEETING_ID>
   ```

3. **Rejoin as Agent**
   ```
   POST /api/meetings?type=agent&meeting_id=<MEETING_ID>
   ```

## Setup

### 1. Environment Variables
Create `.env` file in project root:
```
API_KEY=your_api_key
BASE_URL=https://your-api-endpoint.com
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Build

**Android:**
```bash
flutter build apk --debug
```

**iOS:**
```bash
cd ios && pod install && cd ..
flutter build ios
```

## Usage Flow

### Agent (Host)
1. Launch app → Tap "Create Meeting"
2. Waiting screen shows QR code + copy options
3. Share meeting data with client
4. Tap "Join Meeting" to start the call
5. Use controls to mute/unmute, toggle video
6. Tap back arrow to end call

### Client
1. Launch app → Tap "Join Meeting"
2. Choose method:
   - **Scan QR**: Point camera at host's QR code
   - **Paste Data**: Paste shared JSON data
3. Automatic API call to get client credentials
4. Navigate to video call screen

## Known Limitations

- Client join API returns only MeetingId + AttendeeInfo (no MediaPlacement)
- Workaround: Client uses MediaPlacement from shared data + gets own AttendeeInfo from API
- iOS: Requires camera permission for QR scanning

## Dependencies

- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `dio` - HTTP client
- `flutter_dotenv` - Environment variables
- `permission_handler` - Runtime permissions
- `qr_flutter` - QR code generation
- `mobile_scanner` - QR code scanning
- `flutter_aws_chime` - AWS Chime SDK (local plugin)

## Platform Configuration

### Android
- Camera permission: `android.permission.CAMERA`
- Microphone permission: `android.permission.RECORD_AUDIO`
- Deep link scheme: `himani://`

### iOS
- Camera permission in Info.plist
- Microphone permission in Info.plist
- URL scheme: `himani://`