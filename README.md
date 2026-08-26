# kezorm

A Claude Code marketplace for durable engineering practices. Ships plugins that help teams keep verifiable records of what happened, why, and what they decided.

## Plugins

### [journal](plugins/journal)

Keep an append-only engineering journal (devlog) with a SessionEnd hook that reminds you to record what happened. Promote significant decisions to Architecture Decision Records (ADRs) for durability.

Install with:
```bash
/plugin marketplace add kezorm/claude-journal
/plugin install journal@kezorm
```

Use `/journal` to write an entry or record a decision as an ADR. See [plugins/journal/README.md](plugins/journal/README.md) for details.

## Why this exists

The failure mode of any journal is forgetting to write it. Dead ends and verification details save the next person a day. But a journal is unsearchable by intent — six months on, nobody can find "why are we using X" in 4,000 lines of chronology.

The journal plugin splits the work: chronological narrative entries capture what happened and what failed; Architecture Decision Records keep decisions durable and citable. The SessionEnd hook gently reminds you to update the journal if code changed.

## Adding more plugins

This is a monorepo. To add a new plugin:

1. Create `plugins/<name>/` with your plugin structure
2. Add an entry to the `plugins` array in [marketplace.json](.claude-plugin/marketplace.json)
3. Write a README at `plugins/<name>/README.md`

## License

MIT. See [LICENSE](LICENSE).

## Credits

The ADR calibration checks — the genericness test, two-credible-alternatives minimum, and "all-upside consequences mean you stopped early" — were sharpened after reading [atlas-adr](https://github.com/jeremylongshore/claude-code-plugins-plus-skills/tree/main/plugins/ai-agency/tonone/skills/atlas-adr) by tonone-ai (MIT).
