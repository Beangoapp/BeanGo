# BeanGo Design Specification v1.0

**Product:** BeanGo  
**Domain:** beango.app  
**Owner:** Dr. Ali Albinali  
**Status:** Approved foundation for implementation

## 1. Product Design Direction

BeanGo is a premium global coffee platform that should feel calm, intelligent, fast, and personal. The interface must not look like a generic food-delivery app.

Core principles:

1. **Personal first** — recommendations start from the user's routine, time, weather, and preferences.
2. **One primary action** — each screen has one obvious main action.
3. **Quiet premium** — minimal decoration, restrained color, generous spacing.
4. **Fast by default** — repeat ordering should take one tap where possible.
5. **Bilingual from day one** — Arabic and English must have equal visual quality.

## 2. Design Tokens

### Colors

| Token | Value | Usage |
|---|---:|---|
| `espresso` | `#2B1D16` | Primary text, dark surfaces |
| `roast` | `#4A3024` | Secondary dark surface |
| `caramel` | `#C98642` | Primary accent and CTA |
| `cream` | `#F7F3EE` | Main light background |
| `milk` | `#FFFDF9` | Cards and elevated surfaces |
| `latte` | `#E8D8C8` | Soft highlights |
| `textPrimary` | `#171411` | Main body text |
| `textSecondary` | `#746C65` | Supporting text |
| `success` | `#2E9B63` | Success states |
| `error` | `#D94A45` | Error states |

### Spacing

Use an 8-point grid:

`4, 8, 12, 16, 24, 32, 40, 48, 64`

### Radius

- Small controls: `12`
- Input fields: `16`
- Cards: `20`
- Hero cards: `28`
- Pills: `999`

### Typography

- English: system font / SF Pro where available
- Arabic: Noto Sans Arabic or equivalent system-safe fallback
- Display: 40/44, weight 700
- H1: 32/38, weight 700
- H2: 24/30, weight 600
- Body: 16/24, weight 400
- Caption: 13/18, weight 400

## 3. Motion

- Standard transition: `240ms`
- Emphasized transition: `320ms`
- Use ease-out for entrances and ease-in-out for page transitions
- No decorative animation without a usability purpose
- Respect reduced-motion accessibility settings

## 4. Welcome Experience

This replaces a traditional three-page onboarding carousel.

### Layout

1. Full-screen cream background
2. BeanGo mark at the top
3. Single premium coffee visual in the center
4. Headline:
   - English: **Your coffee knows you.**
   - Arabic: **قهوتك تعرفك.**
5. Supporting copy:
   - English: `Discover, order, and enjoy coffee tailored to your taste.`
   - Arabic: `اكتشف واطلب واستمتع بقهوة تناسب ذوقك.`
6. One primary button:
   - English: `Get started`
   - Arabic: `ابدأ الآن`
7. Secondary language action as text only

### Acceptance criteria

- No carousel
- No skip button
- No heavy shadows
- No gradients unless subtle and approved
- Arabic layout is fully RTL
- Button remains reachable on small screens
- Screen passes widget tests

## 5. Authentication

Preferred order:

1. Phone number
2. One-time verification code
3. Optional Apple / Google sign-in

Rules:

- Keep authentication to one task per screen
- Never ask for unnecessary personal data
- Show clear privacy language
- Use country selector with Qatar preselected only when locale indicates Qatar

## 6. Home Screen Direction

The home screen should prioritize intelligence and speed.

Hierarchy:

1. Greeting and context
2. Today's recommendation
3. One-tap reorder
4. Nearby cafés
5. Rewards summary

The AI should feel embedded in recommendations, not represented by a cartoon robot.

## 7. Navigation

Initial bottom navigation:

- Home
- Explore
- Orders
- Rewards
- Profile

Avoid a floating center action until validated through user testing.

## 8. Accessibility

- Minimum touch target: `44x44`
- Minimum body contrast: WCAG AA
- Support text scaling
- Screen-reader labels required for all interactive controls
- Do not communicate status using color alone

## 9. Engineering Rules

- All colors, spacing, typography, radii, and motion values must come from shared tokens
- No hard-coded strings in widgets
- No hard-coded colors inside feature screens
- Reusable UI belongs in `lib/shared/`
- Feature-specific widgets remain inside their feature package
- Every screen requires at least one widget test

## 10. Sprint 2 Definition of Done

Sprint 2 is complete only when:

- Welcome Experience implemented in Arabic and English
- Language switching works correctly
- Login screen implemented
- GoRouter flow is connected
- Shared button, spacing, and typography components exist
- `flutter analyze` passes
- Tests pass
- Changes are committed and pushed to GitHub
