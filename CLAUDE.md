# file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

- **Ruby 3.4.5** / **Rails 8.1**
- **PostgreSQL** (primary DB)
- **Propshaft** (asset pipeline — no compilation step, just digest fingerprinting)
- **Solid Cache / Solid Queue / Solid Cable** — database-backed adapters replacing Redis
- **Kamal** for deployment (Docker-based)

## Commands

```bash
# Setup (install gems, prepare DB, start server)
bin/setup

# Start dev server
bin/dev

# Rails console / tasks
bin/rails console
bin/rails db:migrate
bin/rails db:prepare   # create + migrate + seed if needed
bin/rails db:reset     # drop, create, migrate, seed

# Linting (runs rubocop-rails-omakase style)
bin/rubocop

# Security scanning
bin/brakeman --no-pager     # static analysis for Rails vulns
bin/bundler-audit           # checks gems against known CVEs
```

## CI

CI runs on PRs and pushes to `main` (see `.github/workflows/ci.yml`). Three jobs:
1. `scan_ruby` — brakeman + bundler-audit
2. `lint` — rubocop with GitHub annotations

There is currently **no test suite** — `rails/test_unit/railtie` is commented out in `config/application.rb` and no `test/` directory exists.

## Architecture Notes

### Production databases
Production uses **four separate PostgreSQL databases** (configured in `config/database.yml`):
- `primary` — main app data
- `cache` — solid_cache (replaces Redis for Rails.cache)
- `queue` — solid_queue (replaces Sidekiq/Redis for Active Job)
- `cable` — solid_cable (replaces Redis for Action Cable)

Each has its own migrations path (`db/cache_migrate`, `db/queue_migrate`, `db/cable_migrate`).

### Generators
`config/application.rb` disables asset and helper generation by default:
```ruby
config.generators.assets = false
config.generators.helper = false
config.generators.system_tests = nil
```

### Routes / Controllers
Routes are empty (scaffold only). The app is a clean Rails 8.1 starting point with:
- `ApplicationRecord` and `ApplicationController` base classes only
- No models, migrations, or routes yet defined

### Style
Rubocop uses `rubocop-rails-omakase` — the Rails team's opinionated defaults. No custom overrides are active.
