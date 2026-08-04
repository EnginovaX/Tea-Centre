---
name: Saffron & Steam
colors:
  surface: '#fff8f5'
  surface-dim: '#e1d8d4'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fbf2ed'
  surface-container: '#f5ece7'
  surface-container-high: '#efe6e2'
  surface-container-highest: '#e9e1dc'
  on-surface: '#1e1b18'
  on-surface-variant: '#554336'
  inverse-surface: '#34302c'
  inverse-on-surface: '#f8efea'
  outline: '#887364'
  outline-variant: '#dbc2b0'
  surface-tint: '#8f4e00'
  primary: '#8f4e00'
  on-primary: '#ffffff'
  primary-container: '#ff9933'
  on-primary-container: '#693800'
  inverse-primary: '#ffb77a'
  secondary: '#934b19'
  on-secondary: '#ffffff'
  secondary-container: '#ffa26a'
  on-secondary-container: '#783603'
  tertiary: '#60603e'
  on-tertiary: '#ffffff'
  tertiary-container: '#b5b48b'
  on-tertiary-container: '#464626'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdcc2'
  primary-fixed-dim: '#ffb77a'
  on-primary-fixed: '#2e1500'
  on-primary-fixed-variant: '#6d3a00'
  secondary-fixed: '#ffdbc9'
  secondary-fixed-dim: '#ffb68c'
  on-secondary-fixed: '#321200'
  on-secondary-fixed-variant: '#753401'
  tertiary-fixed: '#e6e5b9'
  tertiary-fixed-dim: '#cac99f'
  on-tertiary-fixed: '#1d1d03'
  on-tertiary-fixed-variant: '#484828'
  background: '#fff8f5'
  on-background: '#1e1b18'
  surface-variant: '#e9e1dc'
typography:
  headline-xl:
    fontFamily: Montserrat
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 30px
  headline-md:
    fontFamily: Montserrat
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  price-display:
    fontFamily: Montserrat
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 22px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  container-margin-mobile: 16px
  container-margin-desktop: 64px
  gutter: 16px
---

## Brand & Style

The design system is centered on the concept of "Modern Hospitality." It aims to evoke the warmth of a traditional Indian tea stall (Chai Tapri) filtered through a contemporary, minimalist lens. The target audience includes busy professionals and students looking for a comforting, high-quality snack break.

The visual style is **Warm Minimalism**. It prioritizes heavy whitespace (using the Cream base) to let vibrant food photography take center stage. While the aesthetic is clean and uncluttered, the use of rich, earth-toned accents ensures the interface feels appetizing and inviting rather than sterile. The emotional response should be one of immediate craving followed by the ease of a seamless transaction.

## Colors

This design system utilizes a palette inspired by the raw ingredients of the snack experience.

*   **Primary (Saffron Orange):** Used for primary actions, notifications, and brand highlights. It represents energy and spice.
*   **Secondary (Tea Brown):** Used for typography, iconography, and grounding elements. It provides the necessary contrast and organic feel.
*   **Tertiary (Cream):** The primary background color. It is softer than pure white, reducing eye strain and enhancing the "warm" brand persona.
*   **Neutral (Charcoal):** Reserved for high-contrast body text to ensure maximum readability against the cream background.

## Typography

The typography strategy balances high-impact headers with highly legible body text. **Montserrat** provides a geometric, confident structure for headlines, while **Be Vietnam Pro** offers a warm, contemporary feel for descriptions and UI labels.

- Use `headline-xl` for hero sections and category entrances.
- Use `price-display` specifically for product costs to ensure they are immediately scannable.
- Maintain `body-md` as the standard for all product descriptions to ensure a comfortable reading experience on mobile devices.

## Layout & Spacing

This design system uses a **Fluid Grid** model optimized for a mobile-first experience.

- **Mobile:** A 4-column grid with 16px margins. Elements typically span the full width or 2 columns for side-by-side product cards.
- **Desktop:** A 12-column grid with a maximum content width of 1280px and 64px margins.
- **Rhythm:** All spacing must be a multiple of 4px. Use `lg` (24px) for vertical padding between distinct sections and `md` (16px) for internal component padding.

## Elevation & Depth

To maintain the minimalist aesthetic, depth is achieved through **Tonal Layers** and **Soft Ambient Shadows**.

- **Surface Level 0:** The Cream (#FFFDD0) background.
- **Surface Level 1 (Cards):** Pure white background with a very soft, diffused shadow (0px 4px 20px, 5% opacity of Tea Brown) to separate snacks from the main background.
- **Surface Level 2 (Floating Actions):** Higher elevation using a Saffron-tinted shadow to indicate interactivity.
- **Outlines:** Use 1px Tea Brown borders at 10% opacity for input fields and secondary buttons to define shape without adding visual weight.

## Shapes

The shape language is friendly and approachable. 

- Standard components (Cards, Inputs) use the **Rounded** (0.5rem) setting.
- **Interactive Elements:** Buttons and Category Chips use a full "Pill" radius to encourage tapping.
- **Images:** Food photography should always feature rounded corners to match the UI containers, avoiding any sharp geometric breaks that might feel "industrial."

## Components

### Snack Cards
The hero of the UI. Each card must feature a full-bleed or large-inset image at the top. The bottom section contains the title in `headline-md`, a short description in `body-sm`, and a `price-display` in the bottom left. The background is pure white to make the snack colors pop against the cream page.

### Floating Action Button (FAB)
The 'Add to Cart' or 'View Basket' action is a prominent, pill-shaped Saffron Orange button. On mobile, it is anchored to the bottom right or centered at the bottom. Use a white icon and Montserrat SemiBold for any text within.

### Category Chips
Horizontal scrolling list of filters (e.g., "Hot Chai," "Samosas," "Combos"). Use a pill shape with a Tea Brown outline; when active, fill with Saffron Orange and change text to white.

### Input Fields
Used for search and address entry. These should be 48px high (touch-friendly), featuring a cream-tinted background and a subtle Tea Brown border.

### Price Tags
Overlay these on the corner of snack images using a semi-transparent Tea Brown background with Saffron Orange text for a premium, boutique feel.