# Power BI Design Specification

## Design intent

The dashboard should feel like an executive analytics product rather than a collection of Power BI visuals.

The visual language is deliberately restrained: strong typography, generous spacing, a warm neutral canvas, one primary accent, and attention colours used only when a metric genuinely needs attention.

The guiding principle is:

> **Show the business signal first. Give the user enough evidence to understand it. Then make the next question obvious.**

---

## Global visual system

### Typography

Use one modern sans-serif family consistently.

**Preferred:** Aptos / Aptos Display

Fallback: Segoe UI

Suggested hierarchy:

- Page title: 24–28 pt, semibold
- Section heading: 14–16 pt, semibold
- KPI value: 24–32 pt, semibold
- KPI label: 10–11 pt, regular or medium
- Chart title: 12–14 pt, semibold
- Supporting text: 9–10 pt

Avoid mixing multiple font families.

### Colour philosophy

Use colour to encode meaning, not decoration.

- Canvas: warm off-white
- Primary text: charcoal
- Secondary text: muted grey
- Primary accent: restrained blue / teal
- Attention: amber
- Problem / exception: red
- Positive movement: reserved green only where useful

Do not give every category a different bright colour.

### Layout

- Use a consistent page margin.
- Align cards and visuals to an invisible grid.
- Leave deliberate whitespace between analytical sections.
- Avoid borders around every visual.
- Use subtle backgrounds or thin separators to establish hierarchy.

---

# Page 01 — The Business Pulse

### Purpose

Give an executive a fast answer to: **How is the business performing, where is the value concentrated, and what deserves a closer look?**

### Top row

Four KPI cards:

1. Revenue
2. Orders
3. Customers
4. Average Order Value

Each card should show:

- headline value
- short metric label
- optional period/context line

Do not overload cards with secondary statistics.

### Main analytical area

**Left / larger visual:** Revenue over time

- Use a clean line chart.
- Highlight the overall movement rather than every individual point.
- Use month/year consistently.

**Right / supporting visual:** Revenue by product category

- Horizontal bars.
- Sort descending.
- Show labels directly where practical.
- Keep category colours restrained.

### Lower analytical area

**Payment mix:** 100% stacked bar or clean horizontal composition chart.

**Executive insight panel:** 2–3 concise observations written as interpretations, not generic descriptions.

Example structure:

> **Signal** — Revenue is concentrated in a small number of categories.
>
> **Why it matters** — Those categories are useful starting points for deeper commercial analysis.
>
> **Next question** — Is revenue concentration supported by healthy margins?

Do not claim profitability because the source data does not contain margin/cost information sufficient to calculate it.

---

# Page 02 — The Customer Experience

### Purpose

Connect the commercial transaction with the experience that follows it.

### Top row

Four KPI cards:

1. Average Delivery Days
2. Late Delivery Rate
3. Average Review Score
4. Freight Value / relevant freight KPI

### Main analytical area

**Delivery performance:** distribution or trend of delivery time.

**Geography:** state-level comparison of delivery time or late-delivery rate.

Prefer a ranked bar chart when geography does not require a map. Use a map only if spatial context materially improves interpretation.

### Customer experience relationship

Use a scatter plot or grouped comparison to explore delivery performance against review scores where the underlying grain supports the analysis.

The visual should be framed as an observed relationship, not causal proof.

### Insight panel

Surface the strongest operational signal and its business implication without overstating the evidence.

---

# Optional Page 03 — The Opportunity Room

If the existing data model supports it, add a decision-oriented page rather than another descriptive dashboard.

Organise findings into three areas:

### Commercial signals

- Category concentration
- Revenue trends
- Payment concentration

### Customer signals

- Review distribution
- Repeat-customer behaviour where measurable
- Regional differences

### Operational signals

- Late-delivery concentration
- Delivery-time outliers
- Freight burden

Each signal should follow:

**Observation → Evidence → Question to investigate**

This page should not become a recommendation board full of unsupported prescriptions.

---

## Chart selection rules

| Business question | Preferred visual |
|---|---|
| How is revenue changing? | Line chart |
| Which categories lead? | Horizontal bar |
| How is revenue split? | 100% stacked bar |
| How does delivery vary? | Distribution / bar |
| Where are delays concentrated? | Ranked bar; map only if spatial context helps |
| Are two measures related? | Scatter plot |
| How does a KPI change across segments? | Bar / small multiples |

Avoid pie/donut charts unless the number of categories is very small and composition is the actual question.

---

## Titles should answer the question

Avoid:

- Sales Trend
- Category Analysis
- Delivery Performance

Prefer:

- **Revenue accelerated through the strongest trading periods**
- **A small group of categories carries a large share of revenue**
- **Delivery delays are concentrated rather than evenly distributed**

Use neutral wording when the evidence does not support a directional interpretation.

---

## Interaction design

Recommended slicers:

- Date / year
- Product category
- Customer state
- Payment type

Keep slicers compact and consistent. Do not let filters dominate the page.

Where possible, add:

- Report-page tooltips
- Clear filter/reset interaction
- Cross-highlighting between related visuals
- Consistent number formatting

---

## Number formatting

Use business-friendly formats:

- Revenue: currency with sensible abbreviation
- Orders: `99K` style where space is limited
- Rates: one decimal place unless greater precision is genuinely useful
- Ratings: one or two decimals depending on the visual
- Delivery days: one decimal where appropriate

Avoid unnecessary decimal precision.

---

## Final quality check

Before publishing a screenshot or portfolio version, verify:

- Every KPI has a documented definition.
- Order-level metrics are not inflated by one-to-many joins.
- Titles describe the analytical question.
- Colours have consistent meaning.
- Labels are readable at GitHub screenshot size.
- No visual exists solely because the page has empty space.
- Insights distinguish observations from recommendations.
- Historical Olist data is not presented as current market performance.
