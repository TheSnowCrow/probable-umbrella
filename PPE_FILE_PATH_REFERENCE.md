# File Path Reference & Quick Lookup

## KEY FILES YOU'LL NEED TO MODIFY

### 1. Navigation Files

**File**: `/tmp/repo_analysis/_layouts/default.html`
**What**: Main page layout with header navigation
**Action**: Add clinic tracker link to "Documentation Tools" dropdown
**Line Reference**: Lines 40-49 (Documentation Tools dropdown section)

**File**: `/tmp/repo_analysis/_includes/footer.html`  
**What**: Site footer with navigation columns
**Action**: Add clinic tracker link to "Documentation Tools" section
**Line Reference**: Lines 46-54 (Documentation Tools column)

### 2. Styling Files

**File**: `/tmp/repo_analysis/assets/css/style.scss`
**What**: Master stylesheet with all design tokens
**What to Use**: CSS custom properties defined in lines 15-100
**Key Properties**:
- Colors: `--color-primary`, `--color-secondary`, `--color-accent`, etc.
- Spacing: `--space-1` through `--space-16` (4px to 128px)
- Typography: `--font-family-primary`, `--font-size-xs` through `--font-size-5xl`
- Effects: `--shadow-sm` through `--shadow-xl`, `--radius-*`, `--transition-*`

**Import in custom CSS**:
```scss
// At the top of your tracker styles:
@import "minima";  // Inherits all design tokens
```

### 3. Example Tool Files (Use as Templates)

**File**: `/tmp/repo_analysis/cpt-calculator.md`
**Pattern**: Interactive calculator with inline HTML/CSS/JS
**Lines 1-50**: Front matter + header structure
**Good for**: Understanding form layout, collapsible sections, styling pattern

**File**: `/tmp/repo_analysis/snippet-manager.md`
**Pattern**: LocalStorage-based data persistence
**Use for**: Understanding browser storage patterns, export/import functionality

**File**: `/tmp/repo_analysis/prompt-generator.md`
**Pattern**: Two-column layout (form + preview)
**Use for**: Understanding responsive grid layout

**File**: `/tmp/repo_analysis/clinical-ai-course.md`
**Pattern**: Data-driven content from YAML
**Use for**: If tracker needs courses or structured data

### 4. JavaScript Examples

**File**: `/tmp/repo_analysis/assets/js/dropdown.js`
**Lines**: 37 lines total
**Pattern**: Event binding, mobile breakpoint detection
**Key Methods**: `addEventListener`, class toggling, window resize handling

**File**: `/tmp/repo_analysis/assets/js/course-exercise.js`
**Lines**: 650 lines
**Pattern**: Class-based architecture with initialization
**Key Pattern**: Constructor + init() + bindEvents() + state management

### 5. Layout Templates

**File**: `/tmp/repo_analysis/_layouts/default.html`
**Lines 1-15**: Basic structure (include head.html, open body, include footer.html)
**Lines 7-84**: Full page template with header + nav + main content area

**File**: `/tmp/repo_analysis/_includes/head.html`
**What**: Meta tags, CSS imports, script loading
**Note**: Already imports design token CSS via style.css

**File**: `/tmp/repo_analysis/_includes/footer.html`
**What**: Grid-based footer with multiple columns
**Pattern**: Reusable link structure for your navigation

---

## DIRECTORY STRUCTURE

```
/tmp/repo_analysis/
├── _config.yml                    # Jekyll config (don't modify for tracker)
├── _layouts/
│   ├── default.html              # MODIFY: Add tracker nav link
│   ├── post.html
│   ├── course.html
│   └── course_module.html
├── _includes/
│   ├── head.html
│   ├── footer.html               # MODIFY: Add tracker link
│   ├── google-analytics.html
│   └── [other includes]
├── assets/
│   ├── css/
│   │   └── style.scss            # REFERENCE: Design tokens
│   └── js/
│       ├── dropdown.js           # REFERENCE: Event binding pattern
│       └── course-exercise.js    # REFERENCE: Class structure
├── _data/
│   ├── course_exercises.yml      # REFERENCE: YAML data pattern
│   ├── course_transcripts.yml
│   └── diagnosis_cases.yml
├── cpt-calculator.md             # REFERENCE: Tool template
├── prompt-generator.md           # REFERENCE: Two-column layout
├── snippet-manager.md            # REFERENCE: LocalStorage pattern
├── clinical-ai-course.md         # REFERENCE: Course structure
├── index.md                       # Homepage
└── [other pages]

NEW FILES TO CREATE:
├── clinic-visit-tracker.md       # Main tracker page
└── assets/
    ├── js/
    │   └── clinic-visit-tracker.js   (optional, if >300 lines)
    └── css/
        └── clinic-tracker.scss       (optional, if >200 lines)
```

---

## SPECIFIC CODE REFERENCES

### CSS Variables to Use

From `/tmp/repo_analysis/assets/css/style.scss` (lines 15-100):

```css
:root {
  /* Colors (clinical/professional palette) */
  --color-primary: #2563eb;           /* Main blue - use for buttons, links */
  --color-primary-dark: #1e40af;      /* Hover state for --color-primary */
  --color-primary-light: #dbeafe;     /* Light backgrounds */
  
  --color-secondary: #0891b2;         /* Medical teal - complementary */
  --color-secondary-dark: #0e7490;
  --color-secondary-light: #cffafe;
  
  --color-accent: #7c3aed;            /* Purple - CTAs, important actions */
  --color-accent-dark: #6d28d9;
  --color-accent-light: #ede9fe;
  
  --color-success: #059669;           /* Green - completed, saved */
  --color-warning: #d97706;           /* Orange - alerts, caution */
  --color-error: #dc2626;             /* Red - errors, critical */
  
  /* Text colors */
  --color-text-primary: #1f2937;      /* Dark text - body content */
  --color-text-secondary: #6b7280;    /* Medium gray - secondary text */
  --color-text-tertiary: #9ca3af;     /* Light gray - hints, small text */
  
  /* Background colors */
  --color-bg-primary: #ffffff;        /* White - main bg */
  --color-bg-secondary: #f9fafb;      /* Off-white - sections */
  --color-bg-tertiary: #f3f4f6;       /* Light gray - disabled states */
  --color-border: #e5e7eb;            /* Border color */
  
  /* Typography - system font stack (no custom fonts) */
  --font-family-primary: -apple-system, BlinkMacSystemFont, "Segoe UI", ...;
  --font-family-mono: "SF Mono", Monaco, ...;
  
  /* Font sizes (px to rem conversion guide) */
  --font-size-xs: 0.75rem;      /* 12px - labels, captions */
  --font-size-sm: 0.875rem;     /* 14px - small text */
  --font-size-base: 1rem;       /* 16px - body text */
  --font-size-lg: 1.125rem;     /* 18px - secondary headings */
  --font-size-xl: 1.25rem;      /* 20px - section headers */
  --font-size-2xl: 1.5rem;      /* 24px - page headers */
  --font-size-3xl: 1.875rem;    /* 30px */
  --font-size-4xl: 2.25rem;     /* 36px - large headers */
  --font-size-5xl: 3rem;        /* 48px - hero headers */
  
  /* Font weights */
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
  
  /* Line heights */
  --line-height-tight: 1.25;
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.75;
  
  /* Spacing - 8px grid system */
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-3: 0.75rem;   /* 12px */
  --space-4: 1rem;      /* 16px - standard padding */
  --space-5: 1.5rem;    /* 24px */
  --space-6: 2rem;      /* 32px - card padding */
  --space-8: 3rem;      /* 48px - section gaps */
  --space-10: 4rem;     /* 64px */
  --space-12: 6rem;     /* 96px */
  --space-16: 8rem;     /* 128px */
  
  /* Border radius */
  --radius-sm: 0.25rem;    /* 4px - small elements */
  --radius-md: 0.5rem;     /* 8px - buttons, inputs */
  --radius-lg: 0.75rem;    /* 12px - cards */
  --radius-xl: 1rem;       /* 16px - large panels */
  --radius-full: 9999px;   /* Circles, pill-shaped */
  
  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), ...;
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), ...;
  --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), ...;
  
  /* Transitions - for smooth interactions */
  --transition-fast: 150ms ease-in-out;
  --transition-base: 250ms ease-in-out;    /* Default for most interactions */
  --transition-slow: 350ms ease-in-out;
  
  /* Layout constraints */
  --max-width-sm: 640px;
  --max-width-md: 768px;
  --max-width-lg: 1024px;
  --max-width-xl: 1280px;
}
```

### HTML/CSS Patterns from Existing Tools

**Responsive Grid Pattern** (from prompt-generator.md, cpt-calculator.md):
```css
.main-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  align-items: start;
}

@media (max-width: 1200px) {
  .main-layout {
    grid-template-columns: 1fr;
  }
}
```

**Card Style Pattern**:
```css
.card {
  background: var(--color-bg-primary);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  box-shadow: var(--shadow-sm);
}
```

**Button Style Pattern**:
```css
.btn {
  background: var(--color-primary);
  color: white;
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  border: none;
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: var(--transition-base);
}

.btn:hover {
  background: var(--color-primary-dark);
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}
```

**Form Input Pattern** (from CPT calculator):
```css
input, textarea, select {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  font-family: var(--font-family-primary);
  font-size: var(--font-size-base);
  transition: var(--transition-base);
}

input:focus, textarea:focus, select:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px var(--color-primary-light);
}
```

### JavaScript Initialization Pattern

From `dropdown.js` and `course-exercise.js`:

```javascript
// Basic initialization pattern
document.addEventListener('DOMContentLoaded', function() {
  // Only runs after DOM is fully loaded
  const element = document.getElementById('your-element-id');
  
  if (element) {
    // Initialize your class/functionality
    new ClinicVisitTracker('tracker-container');
  }
});
```

### LocalStorage Pattern

From `snippet-manager.md`:

```javascript
class DataManager {
  constructor(storageKey) {
    this.key = storageKey;
    this.load();
  }
  
  load() {
    const stored = localStorage.getItem(this.key);
    this.data = stored ? JSON.parse(stored) : [];
  }
  
  save() {
    localStorage.setItem(this.key, JSON.stringify(this.data));
  }
  
  add(item) {
    this.data.push({ ...item, id: Date.now() });
    this.save();
  }
  
  remove(id) {
    this.data = this.data.filter(item => item.id !== id);
    this.save();
  }
}
```

---

## NAVIGATION MENU LOCATIONS

**Header Navigation** (file: `/_layouts/default.html`):
```html
<!-- Lines 32-62 -->
<div class="dropdown">
  <span class="page-link">Documentation Tools</span>
  <div class="dropdown-content">
    <!-- Add your link here -->
  </div>
</div>
```

**Footer Navigation** (file: `/_includes/footer.html`):
```html
<!-- Lines 46-54 -->
<div>
  <h3>Documentation Tools</h3>
  <ul style="list-style: none; padding: 0; margin: 0;">
    <!-- Add your link here -->
  </ul>
</div>
```

---

## JEKYLL COLLECTIONS REFERENCE

From `/_config.yml` (lines 29-42):

```yaml
collections:
  prompts:
    output: true
    permalink: /prompts/:path/
  dotphrases:
    output: false
    permalink: /dotphrases/:path/
  courses:
    output: true
    permalink: /courses/:name/
  course_modules:
    output: true
    permalink: /courses/:course/:name/
```

**If you need a tracker collection:**
```yaml
  trackers:
    output: true
    permalink: /trackers/:name/
```

Then create folder: `/_trackers/`
And files: `/_trackers/clinic-visit-tracker.md`, etc.

---

## QUICK FILE PATH SUMMARY

| Purpose | File Path | Type | Modify? |
|---------|-----------|------|---------|
| Main navigation | `/_layouts/default.html` | HTML | Yes |
| Footer links | `/_includes/footer.html` | HTML | Yes |
| Design tokens | `/assets/css/style.scss` | SCSS | Reference only |
| JS patterns | `/assets/js/dropdown.js` | JS | Reference only |
| Form template | `/cpt-calculator.md` | MD | Reference only |
| Grid layout | `/prompt-generator.md` | MD | Reference only |
| Storage pattern | `/snippet-manager.md` | MD | Reference only |
| **NEW: Tracker page** | **/clinic-visit-tracker.md** | MD | **Create** |
| **NEW: Tracker JS** | **/assets/js/clinic-visit-tracker.js** | JS | **Create (optional)** |
| **NEW: Tracker CSS** | **/assets/css/clinic-tracker.scss** | SCSS | **Create (optional)** |

