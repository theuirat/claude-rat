---
name: brief
description: Turns a rough product idea or PM ask into a structured design brief — problem, users, goals, constraints, and success metrics. Use at the start of any new piece of work.
argument-hint: <rough description of the feature or problem>
context: fork
disable-model-invocation: true
---

Write a design brief for the following: $ARGUMENTS

Act as a Senior Designer setting up a project for success. The brief should force clarity before anyone opens Figma.

Structure:

**Project name:** [Short, descriptive name]

**Background:**
- [Why this is being worked on. What triggered it — user feedback, business goal, data, etc.]

**Problem statement:**
- [One clear sentence: "We've noticed [observation] which means [impact] for [user]. We believe [solution direction] will [outcome]."]

**Users:**
- Primary: [Who is most affected by this problem]
- Secondary: [Who else interacts with this]
- Out of scope: [Who we are explicitly NOT designing for this time]

**Goals:**
- User goal: [What the user wants to achieve]
- Business goal: [What the company wants to achieve]
- Design goal: [What a great solution looks like]

**Success metrics:**
- [How will we know this worked? What would we measure?]

**Constraints:**
- Time: [Deadline or sprint scope]
- Tech: [Platform, existing components, API limitations]
- Design: [Design system, brand, existing patterns to respect]
- Out of scope: [What we're deliberately not solving this time]

**Open questions before we start:**
- [Anything that needs a decision or more information before design begins]

**References:**
- [Related work, competitor examples, or research to draw from]
