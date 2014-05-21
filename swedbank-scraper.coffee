Browser = require("zombie")
$       = require('cheerio')

module.exports =
class Swedbank
  transactions: []
  url: 
    login: "https://mobilbank.swedbank.se/banking/swedbank/login.html"
    account: "https://mobilbank.swedbank.se/banking/swedbank/account.html?id=0"
    account_next: "https://mobilbank.swedbank.se/banking/swedbank/account.html?id=0&action=next"

  constructor: (@auth = {number: "personnummer", pass: "personlig kod"}) ->
    @browser = new Browser()

  get_transactions: (cb = ->) ->
    @done = -> cb(@transactions)
    @check_account()

  login: ->
    @browser.visit(@url.login)
    .then =>
      @browser.fill "xyz", @auth.number
      @browser.pressButton "Fortsätt"
    .then =>
      @browser.fill "zyx", @auth.pass
      @browser.pressButton "Logga in"
    .then => @check_account()

  check_account: ->
    @transactions = []
    @browser.visit @url.account
    .then =>
      return @login() if @browser.text("H1") is "Logga in"
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
    .then => @done?()

  add_transactions: (dom) ->
    $('.clearfix', dom).each (index, el) =>
      transaction = 
        date: $('.date', el).text()
        name: $('.receiver', el).text()
        amount: $('.amount', el).text()

      expense = parseInt(transaction.amount, 10) < 0
      transaction.type = if expense then "expense" else "income"
      
      if transaction.name
        @transactions.push(transaction) 
