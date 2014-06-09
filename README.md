# CREAM
### get the dough and clone the repo

![some image](http://24.media.tumblr.com/99f3d3d614be1208e8743c7177284008/tumblr_mrs9pnvpNX1rd1m63o1_1280.png)

## What is this I don't even...
* Setup:
    * [Node.js](http://nodejs.org): `brew install node` on OS X
    * [Brunch](http://brunch.io): `npm install -g brunch`
    * Brunch plugins and Bower dependencies: `npm install`.
    * Add .env file `SWEDBANK_USER=person_number SWEDBANK_PASS=personal_code`
* Run:
    * `brunch watch --server` — watches the project with continuous rebuild. This will also launch HTTP server with [pushState](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history).
    * `/transactions` – render json with transactions, it fetches from `cached-transactions.coffee` during development. Change inside `server.coffee` to fetch from server (optionally update cached response and use for future)
* Learn (brunch):
    * `public/` dir is fully auto-generated and served by HTTP server.  Write your code in `app/` dir.
    * Place static files you want to be copied from `app/assets/` to `public/`.
