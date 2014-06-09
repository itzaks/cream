Browser = require("zombie")
$       = require('cheerio')

module.exports =
class Swedbank
  transactions: []
  meta: {}
  url:
    login: "https://mobilbank.swedbank.se/banking/swedbank/login.html"
    account: "https://mobilbank.swedbank.se/banking/swedbank/account.html?id=0"
    account_next: "https://mobilbank.swedbank.se/banking/swedbank/account.html?id=0&action=next"

  constructor: (@auth = {number: "personnummer", pass: "personlig kod"}) ->
    @browser = new Browser()

  get_transactions: (callback = ->) ->
    @done = -> callback { @transactions, @meta }
    @check_account()

  login: ->
    console.log "swedbank:login"
    @browser.visit(@url.login)
    .then =>
      @browser.fill "xyz", @auth.number
      @browser.pressButton "Fortsätt"
    .then =>
      @browser.fill "zyx", @auth.pass
      @browser.pressButton "Logga in"
    .then => 
      console.log "swedbank:login:done"
      @check_account()

  check_account: ->
    @transactions = []
    @meta = {}
    @browser.visit @url.account
    .then =>
      title = @browser.text("H1")
      console.log "swedbank:account:action", title
      return @login() if title is "Logga in"
      @set_meta @browser.html('.mbaccount-list')
      @add_transactions @browser.html(".clearfix")
      @browser.visit @url.account_next
    .then =>
      @add_transactions @browser.html(".clearfix")
      @browser.visit @url.account_next
    .then =>
      @add_transactions @browser.html(".clearfix")
      @browser.visit @url.account_next
    .then =>
      @add_transactions @browser.html(".clearfix")
      @browser.visit @url.account_next
    .then => 
      @done?()

  set_meta: (dom) ->
    amount = $('dd:last-child .amount', dom).text()
    @meta.total_amount = parseInt(amount, 10)

  add_transactions: (dom) ->
    total = @meta.total_amount
    $('.clearfix', dom).each (index, el) =>
      transaction =
        date: $('.date', el).text()
        name: $('.receiver', el).text()
        amount: $('.amount', el).text()
        
      total = total - transaction.amount
      transaction.total_amount = total

      expense = parseInt(transaction.amount, 10) < 0
      transaction.type = if expense then "expense" else "income"
      transaction.id = index

      if transaction.name
        @transactions.push(transaction)
