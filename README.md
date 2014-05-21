# Swedbanx

## ???
* Install (if you don't have them):
    * [Node.js](http://nodejs.org): `brew install node` on OS X
    * [Brunch](http://brunch.io): `npm install -g brunch`
    * Brunch plugins and Bower dependencies: `npm install`.
    * Add following to .env `SWEDBANK_USER=person_number` and `SWEDBANK_PASS=personal_code`
* Run:
    * `brunch watch --server` — watches the project with continuous rebuild. This will also launch HTTP server with [pushState](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history).
    * `/transactions` – render json with transactions, it fetches from `cached-transactions.coffee` during development. Change inside `server.coffee` to fetch from server (optionally update cached response and use for future)
* Learn (brunch):
    * `public/` dir is fully auto-generated and served by HTTP server.  Write your code in `app/` dir.
    * Place static files you want to be copied from `app/assets/` to `public/`.
    * [Brunch site](http://brunch.io), [Chaplin site](http://chaplinjs.org)
