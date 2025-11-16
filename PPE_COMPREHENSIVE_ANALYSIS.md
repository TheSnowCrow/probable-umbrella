# Physician Prompt Engineering - Comprehensive Repository Analysis

## 1. WEBSITE TYPE & ARCHITECTURE

### Technology Stack
- **Static Site Generator**: Jekyll (Ruby-based)
- **Theme**: Minima (Jekyll default theme, heavily customized)
- **Hosting**: GitHub Pages (confirmed by CNAME: physicianpromptengineering.com)
- **Repository**: https://github.com/pedscoffee/PhysicianPromptEngineering

### Build System
- **Gemfile**: Uses `github-pages` gem (bundles Jekyll + all GitHub Pages themes & plugins)
- **No Node.js**: No package.json - no npm build system
- **No Backend**: Purely static content + client-side JavaScript
- **CSS**: Custom SCSS (50KB style.scss) with CSS variables/design tokens
- **JavaScript**: Two lightweight scripts (dropdown.js, course-exercise.js)

### Deployment
- Direct GitHub Pages deployment
- CNAME configured for custom domain
- Jekyll automatically builds on push
- No CI/CD workflows visible (not needed for static site)

---

## 2. FILE STRUCTURE & ORGANIZATION

```
/PhysicianPromptEngineering/
├── _config.yml                 # Jekyll configuration
├── Gemfile                      # Ruby dependencies
├── CNAME                        # GitHub Pages domain
├── _includes/                  # Reusable HTML components
│   ├── head.html              # <head> tag setup
│   ├── footer.html            # Footer with navigation
│   ├── google-analytics.html  # GA tracking
│   ├── beta-notice.html       # Beta warning banner
│   ├── share-prompt-cta.html  # CTA component
│   └── newsletter.html        # Newsletter signup
├── _layouts/                   # Page templates
│   ├── default.html           # Main layout (header + footer)
│   ├── post.html              # Blog post layout
│   ├── course.html            # Course overview layout
│   └── course_module.html     # Individual module layout
├── _data/                      # YAML data files
│   ├── course_exercises.yml   # Exercise definitions
│   ├── course_transcripts.yml # Training transcripts
│   └── diagnosis_cases.yml    # Case study data
├── _posts/                     # Blog posts (chronological)
├── _course_modules/            # Course module content
├── _dotphrases/               # Dot phrase snippets
├── _prompts/                  # Prompt collection
├── assets/
│   ├── css/
│   │   └── style.scss        # All styling (2382 lines)
│   └── js/
│       ├── dropdown.js        # Mobile nav dropdown logic
│       └── course-exercise.js # Interactive course engine
├── images/                     # Static images
├── Root .md files             # Main pages (index.md, about.md, etc.)
└── .git/                       # Version control

YAML Collections (defined in _config.yml):
  - prompts: /prompts/:path/
  - dotphrases: (internal only)
  - courses: /courses/:name/
  - course_modules: /courses/:course/:name/
```

### Key Statistics
- 34 markdown files total
- Repository size: 5.7MB
- Style file: 2,382 lines of SCSS
- Course engine: 650 lines of JavaScript
- No server-side code

---

## 3. HOW PAGES & FEATURES ARE ORGANIZED

### Main Page Structure

#### Homepage (index.md)
- Hero section with CTAs
- Problem statement + solution explanation
- Video demo embedded (YouTube)
- Three key prompt cards
- Feature overview with grid layout

#### Collections-Based Pages
1. **Blog Posts** (`_posts/` directory)
   - Chronological blog articles
   - Tags/categories via Jekyll
   - Layout: `post.html`

2. **Prompt Library** (`_prompts/` collection)
   - Individual prompt pages
   - Automatically indexed
   - Accessible via `/prompts/:path/`

3. **Course System** (`_course_modules/` collection)
   - 5 modules, each with multiple exercises
   - Data-driven from YAML
   - Layout: `course_module.html`
   - Includes LLM-powered feedback system

### Navigation Structure
**Header Navigation** (dropdown menus in default.html):
1. Blog
2. Resources
   - Prompt Library
   - Best Practices
3. Documentation Tools
   - A&P Prompt Generator
   - E&M Calculator
   - Snippet Manager
   - Dot Phrase Library
4. Doc Pixel AI (LLM-powered tools)
   - Overview
   - Interactive Course
   - DDX Challenge Game
   - Doc Pixel's Librarian
   - Cram for Rounds
   - Case Creator
5. Contribute
6. About

### Existing Tools/Features
All embedded directly in markdown pages (.md files):

1. **A&P Prompt Generator** (`/prompt-generator.md`)
   - Two-column layout (form + preview)
   - Client-side form handling
   - No API calls needed

2. **CPT E/M Calculator** (`/cpt-calculator.md`)
   - Interactive calculator
   - Inline JavaScript for calculations
   - Collapsible instructions section

3. **Snippet Manager** (`/snippet-manager.md`)
   - Browser LocalStorage for persistence
   - Privacy-first (no backend)
   - Full CRUD for snippets

4. **Interactive Course** (`/courses/clinical-prompt-engineering/`)
   - Real-time LLM evaluation using MLC Web LLM
   - WebGPU acceleration (Chrome/Edge 113+)
   - ~2GB local model download on first use
   - 14 exercises across 5 modules

5. **Diagnostic Case Creator** (`/diagnosis-case-creator.md`)
   - Form-based case building
   - Real-time output generation

6. **Paper Librarian** (`/paper-librarian.md`)
   - Research paper management tool
   - LocalStorage based

7. **Cram for Rounds** (`/cram-for-rounds.md`)
   - Quick reference builder

---

## 4. STYLING FRAMEWORK

### CSS Architecture
- **No Bootstrap/Tailwind**: Pure custom CSS
- **SCSS**: Preprocessed to CSS
- **CSS Variables**: Extensive design token system
- **Mobile-First**: Responsive grid system included

### Design Token System (CSS Variables)
```scss
/* Color Palette */
--color-primary: #2563eb (Trust Blue)
--color-secondary: #0891b2 (Medical Teal)
--color-accent: #7c3aed (Purple for CTAs)
--color-success/warning/error: Semantic colors
--color-text-primary/secondary/tertiary: Text hierarchy
--color-bg-primary/secondary/tertiary: Background hierarchy

/* Typography */
--font-family-primary: System fonts (SF Pro, Segoe UI, etc.)
--font-family-mono: Monospace for code
--font-size-xs to 5xl: 12px to 48px scale

/* Spacing */
--space-1 to 16: 4px to 128px (8px grid)
--border-radius-sm to full: 4px to 9999px

/* Effects */
--shadow-sm to xl: Shadow depth scale
--transition-fast/base/slow: Animation speeds
```

### Layout System
- Container-based (max-width constraints)
- CSS Grid for multi-column layouts
- Flexbox for components
- Mobile breakpoint: 599px threshold
- Sticky positioning for sidebars

### Key Style Files
- `/assets/css/style.scss` - All styling (2,382 lines)
  - Imports Minima framework first
  - Overrides with custom design system
  - Responsive utilities
  - Component styles

---

## 5. BACKEND & RUNTIME ENVIRONMENT

### Server-Side
**NONE** - Purely static content

- No Python, Node.js, or Ruby runtime on production
- Jekyll builds locally or in GitHub Actions
- No API endpoints
- No database

### Client-Side JavaScript
Only 2 JavaScript files (both lightweight):

1. **dropdown.js** (37 lines)
   - Mobile navigation dropdown functionality
   - Event listeners for menu toggle
   - Window resize handling

2. **course-exercise.js** (650 lines)
   - LLM integration via MLC Web LLM library
   - Loads Llama-3.1-8B model from CDN
   - WebGPU acceleration
   - Handles exercise execution, feedback, hints
   - Imported from CDN: https://esm.run/@mlc-ai/web-llm

### Data Management
- **No backend database**
- **YAML files** for structured data:
  - `_data/course_exercises.yml` - Exercise definitions
  - `_data/course_transcripts.yml` - Training examples
  - `_data/diagnosis_cases.yml` - Case studies
- **LocalStorage** for user data:
  - Snippet Manager
  - Course progress
  - User preferences
- **No authentication**

---

## 6. EXISTING TOOLS & UTILITIES INTEGRATION PATTERNS

### Pattern 1: Markdown Pages with Embedded HTML/CSS
**Example**: CPT Calculator (`cpt-calculator.md`)
```markdown
---
layout: page
title: CPT E/M Code Calculator
permalink: /cpt-calculator/
---

<style>
  /* Page-specific CSS */
</style>

<div class="calculator-container">
  <!-- Interactive UI with inline event handlers -->
</div>

<script>
  // Inline JavaScript for interactivity
</script>
```

### Pattern 2: Data-Driven Collections
**Example**: Course Modules
```yaml
# _config.yml
collections:
  course_modules:
    output: true
    permalink: /courses/:course/:name/
```
Each module file uses front matter to define module number, title, exercises:
```markdown
---
layout: course_module
module_number: 1
title: "Module Title"
course: clinical-prompt-engineering
---
```

### Pattern 3: Included Components
Reusable HTML snippets in `_includes/`:
```html
<!-- _includes/share-prompt-cta.html -->
<!-- Used across multiple pages for consistent CTAs -->
```

### Pattern 4: LocalStorage-Based Persistence
Tools that need to store user data:
- No backend required
- Data persists across sessions
- User data never leaves browser
- Can export/import JSON

---

## 7. HOSTING & DEPLOYMENT

### GitHub Pages Deployment
- **Type**: GitHub Pages (Standard)
- **Domain**: physicianpromptengineering.com (Custom domain via CNAME)
- **Repository**: pedscoffee/PhysicianPromptEngineering
- **Build Process**: Automatic Jekyll compilation on push
- **Branch**: Likely main branch triggers deployment
- **SSL**: Automatic via GitHub Pages (HTTPS enabled)
- **Uptime**: 99.99% (GitHub Pages SLA)

### No Additional Hosting Needed
- No separate web server
- No CDN required (though could be added)
- All assets served from GitHub
- Static file serving only

### Performance Considerations
- Fast delivery via GitHub CDN
- All processing client-side
- Large model download (2GB) for course exercises handled client-side
- Images cached effectively

---

## TECHNOLOGY SUMMARY TABLE

| Aspect | Technology |
|--------|-----------|
| **Static Site Generator** | Jekyll 3.9+ (via github-pages gem) |
| **Templating** | Liquid (Jekyll) |
| **Styling** | SCSS → CSS with custom design tokens |
| **CSS Framework** | None (custom only) |
| **Frontend Framework** | Vanilla JavaScript (no React/Vue) |
| **Backend** | None (static only) |
| **Database** | YAML files (Jekyll data) + LocalStorage (browser) |
| **Hosting** | GitHub Pages + Custom Domain (CNAME) |
| **CLI/Tools** | All browser-based |
| **API** | None (client-side only) |
| **Build Tool** | Jekyll (automatic via GitHub) |
| **Package Manager** | Bundler (Ruby) - Gemfile based |
| **JavaScript Runtime** | Browser (WebGPU capable browsers) |
| **Storage** | Client-side LocalStorage + GitHub pages file system |

