# kezorm

A Claude Code marketplace for durable engineering practices. Ships plugins that help teams keep verifiable records of what happened, why, and what they decided.

## Why this exists

The failure mode of any record is forgetting to keep it. The second failure mode is keeping it in a form nobody can search six months later — the details that would save the next person a day are in there somewhere, under 4,000 lines of chronology.

Every plugin here writes plain markdown into a git repository. No app, no database, no schema to migrate when you discover you need a field nobody anticipated. Each one holds apart the two jobs a record has to do: capture what just happened, and answer a question asked years from now.

## Plugins

### [journal](plugins/journal)

Keep an append-only engineering journal (devlog) with a SessionEnd hook that reminds you to record what happened. Promote significant decisions to Architecture Decision Records (ADRs) for durability.

The split is the point: chronological entries capture what you did and what failed; ADRs keep decisions citable long after the narrative around them has scrolled away. The hook is advisory — it reminds you when code changed but the journal didn't, and never writes an entry itself.

**Local installation:**
```bash
/plugin marketplace add file:///Users/greg/Projects/claude/kezorm
/plugin install journal@kezorm
```

**From community marketplace** (once approved):
```bash
/plugin marketplace add anthropics/claude-plugins-community  # one time
/plugin install journal@claude-community
```

Use `/journal` to write an entry or record a decision as an ADR. See [plugins/journal/README.md](plugins/journal/README.md) for details.

### [asset-log](plugins/asset-log)

Set up and maintain a durable markdown record for something you own — a vehicle, house, boat, or equipment — out of the scattered documents that accumulate around it. Weighted toward the initial setup, which is where it measurably helps; it steps aside once a record carries its own working rules.

**Local installation:**
```bash
/plugin marketplace add file:///Users/greg/Projects/claude/kezorm
/plugin install asset-log@kezorm
```

**From community marketplace** (once approved):
```bash
/plugin marketplace add anthropics/claude-plugins-community  # one time
/plugin install asset-log@claude-community
```

Use `/asset-log` to set up a new log or file documents into an existing one. See [plugins/asset-log/README.md](plugins/asset-log/README.md) for details.

## Adding more plugins

This is a monorepo. To add a new plugin:

1. Create `plugins/<name>/` with your plugin structure
2. Add an entry to the `plugins` array in [marketplace.json](.claude-plugin/marketplace.json)
3. Write a README at `plugins/<name>/README.md`

## License

MIT. See [LICENSE](LICENSE).

## Credits

The journal plugin's ADR calibration checks — the genericness test, two-credible-alternatives minimum, and "all-upside consequences mean you stopped early" — were sharpened after reading [atlas-adr](https://github.com/jeremylongshore/claude-code-plugins-plus-skills/tree/main/plugins/ai-agency/tonone/skills/atlas-adr) by tonone-ai (MIT).
