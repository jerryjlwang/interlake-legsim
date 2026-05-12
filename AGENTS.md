<claude-mem-context>
# Memory Context

# [interlake-legsim] recent context, 2026-05-11 10:04pm PDT

Legend: 🎯session 🔴bugfix 🟣feature 🔄refactor ✅change 🔵discovery ⚖️decision 🚨security_alert 🔐security_note
Format: ID TIME TYPE TITLE
Fetch details: get_observations([IDs]) | Search: mem-search skill

Stats: 50 obs (19,602t read) | 960,659t work | 98% savings

### May 11, 2026
323 9:08a 🔴 Two Security/Reliability Fixes: Dockerfile Asset Precompile and Railway Host Regex Anchored
324 " ✅ Railway Deployment Preparation Complete — All 4 Plan Steps Done, Ready to Commit and Push
325 " 🔵 Railway UI Confusion: User Couldn't Find Where to Add MySQL/Redis Services After Creating Project
326 " ✅ docs/railway-hosting.md Adds "Adding Services After Repo Import" Section for User's Exact Situation
327 9:44a 🔐 Sentry DSN Hardcoded in Commented-Out config/initializers/sentry.rb
328 " 🔵 config/initializers/sidekiq.rb Exists — Redis Connection Config Needs Verification for Railway
329 9:47a 🔵 Railway Worker Crash: REDIS_URL Set to Empty String on Sidekiq Service
330 6:28p 🔴 sidekiq.rb ENV.fetch Cannot Handle Empty REDIS_URL — Needs .presence Guard
331 " 🔴 sidekiq.rb Fixed: ENV.fetch Replaced with .presence to Handle Empty REDIS_URL
332 6:33p 🔵 Sidekiq Worker Now Fails at TCP Connect Stage — Redis URL Valid But Host Unreachable
333 6:34p 🔴 sidekiq.rb Rebuilt with Railway Redis Fallback Using Individual REDISHOST/REDISPORT/REDISPASSWORD Vars
334 " ✅ docs/railway-hosting.md Documents REDISHOST/REDISPORT/REDISUSER/REDISPASSWORD Fallback Variables
335 6:42p 🔵 Docker Build Fails: sidekiq.rb Production Guard Runs During Asset Precompile
336 " 🔴 sidekiq.rb Redis Guard Fixed: SECRET_KEY_BASE_DUMMY Skips Raise During Docker Build
337 6:47p 🔵 Sidekiq Worker Runtime Confirms: REDIS_URL Not Set on Railway Worker Service — Guard Working Correctly
338 6:50p 🔵 Railway Variable Reference Syntax: ${{ServiceName.VARIABLE_NAME}} Autocompletes in Dashboard
339 6:53p 🔵 Railway Redis Autocomplete Not Appearing — Redis Service Likely Not Added to Project
340 6:57p 🔵 Railway "Share Variables" Feature: Redis and MySQL Should Share to Web and Worker Services Only
341 7:01p 🔵 ApplicationController Tracks Every User HTTP Action in Database — Potential Performance Concern
342 " 🔵 User Model Uses localhost SMTP Directly — Bypasses Gmail ActionMailer Config, Will Fail in Production
343 " 🔵 Login Flow Uses Devise-Based View with Course Dropdown — course_id Required for User Auth
344 " 🔴 config/database.yml Rebuilt to Support MYSQL_URL Single Connection String and Credentials Fallback
345 7:05p ✅ docs/railway-hosting.md Documents MYSQL_URL Single URL Option and Local Socket Error
347 " 🔵 Railway MySQL Plugin Exposes MYSQL_URL Only — Individual Component Variables Are Empty
348 " 🔵 Railway Shows Service as "Active" Even When Latest Build Failed — Running Previous Successful Deploy
349 " 🔵 RAILS_ENV and RAILS_LOG_TO_STDOUT Already Set in Dockerfile — Don't Need to Be Set as Railway Service Variables
346 " 🔵 database.yml ERB Preamble Validated — Both MYSQL_URL and Individual Vars Parse Correctly
350 7:20p 🔴 config/database.yml Uses env_value Lambda to Treat Empty Env Vars as Absent
351 7:21p 🔵 env_value Lambda Validated: Empty MYSQLUSER/PASSWORD Strings Correctly Fall Through to MYSQL_URL
352 7:25p 🔵 config/database.yml Final State Confirmed — Complete ERB Preamble with env_value Helper
353 " 🔴 database.yml Enhanced: Multiple MySQL URL Variable Names Tried, Username Guard Added, Whitespace Stripped
354 7:26p 🔴 filter_map Replaced with map+compact for Ruby 2.6 Compatibility in database.yml ERB
355 " ✅ database.yml Fully Validated with map.compact — All URL Variable Names and Production Guard Confirmed Working
357 " 🔵 Worker Service Deployment Crashed — Missing Database or Redis Variables Most Likely Cause
358 " ✅ database.yml Expanded MySQL Variable Coverage — DATABASE, MYSQL_DATABASE_URL, MYSQL_USER, MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD Added
356 " ✅ Railway Deployment Hardening Complete — 3 Files Ready to Commit and Push
359 7:32p 🔵 database.yml Docker-Standard MySQL Variables Validated — MYSQL_USER and MYSQL_ROOT_PASSWORD Work Correctly
360 7:33p 🔴 database.yml Adds url_value Lambda and Root Username Inference from URL Password
361 " ✅ docs/railway-hosting.md Documents Blank-Username MySQL URL Pattern and Root Inference
362 7:34p 🔵 Confirmed: Railway MySQL URL Format is mysql://:password@host — Blank Username Confirmed as Real Railway Pattern
364 " 🔵 interlake-legsim Successfully Deployed on Railway — Hardcoded Legacy URLs Are New Blocker
363 " ✅ database.yml and docs/railway-hosting.md Final State Confirmed — All Changes Validated and Ready to Commit
365 7:40p 🔵 Hardcoded URL Audit: 4 Critical Locations Use Legacy Domains — system_user.rb, letter_user_recipient.rb, user.rb, production.rb
366 " 🔵 APP_CONFIG['domain'] Will Raise NameError — legsim.rb Doesn't Define APP_CONFIG Constant
367 " 🔴 Hardcoded Legacy URLs Fixed — LEGSIM_URL Constant Added to legsim.rb, All 4 URL Locations Updated
368 " ✅ Hardcoded URL Fixes Validated — 6 Files Ready to Commit, legsim.rb Missing Newline Also Fixed
369 " 🔵 info.legsim.org Links Are Now Inactive — Primarily in Tutorial/Instruction Content YAML Files
370 8:26p 🔵 Comprehensive info.legsim.org Audit: PDFs Don't Exist Locally — No Replacement URL Available Yet
372 " 🔴 info.legsim.org Links Fixed — LEGSIM_INFO_URL Constant Added with Wayback Machine Fallback
371 8:27p 🔵 Scenario YAML Content Loads Into Database — Fixing YAML Files Won't Fix Existing info.legsim.org Links in DB

Access 961k tokens of past work via get_observations([IDs]) or mem-search skill.
</claude-mem-context>