---
{
  "type": "blog",
  "author": "Jordane Grenat",
  "title": "Promises vs Observables",
  "description": "Réflexions personnelles autour du framework agile Scrum et la façon dont il est utilisé / devrait être utilisé aujourd'hui.",
  "image": "images/article-covers/post-it.png",
  "published": "2019-10-22",
}
---

JavaScript loves having many ways to do the same thing. And asynchronous operations being at the heart of the language, it's not surprising to have more than four different ways of dealing with it!

The first and simplest one is callbacks. But if you're old enough in the profession to have encountered *callback hell*, you know that this solution brings many problems to the table if you're not cautious.

```javascript
getLoggedInUser((err, user) => {
  if (err) {
    displayError();
    return;
  }
  getMoviesForUser(user, (err, userMovies) => {
    if (err) {
      displayError();
      return;
    }
    getMovieDetails(userMovies[0], (err, movieDetails) => {
      if (err) {
        displayError();
        return;
      }
      displayMovie(movieDetails);
    });
  });
})
```

We can see that dependent asynchronous calls can quickly get to a high level of nesting in your code. You can extract things into functions to avoid that but it rely on the team being cautious. Also, it's the developer duty to think about handling the potential errors, nothing can prevent her/him from using the `user` variable without testing first that there was no error. As anything that needs a special attention, be sure that it will fail one day!

So we've found two *better* ways of dealing with asynchronous operations in JavaScript: promises and observables. But what are their differences and when should you use each?

## Promises

A promise is kind of a box representing an asynchronous operation. It can have three states: pending (the operation is not done yet), resolved with success (the operation was successful and the *box* contains the result) and resolved with an error (the operation failed and the promise contains an error object).

<div style="text-align: center">    
    <img src="/images/promises.png" alt="Diagram of a promise's state: the \"pending\" state can transition to the \"success\" state or the \"error\" state" style="max-width: 100%;">    
</div>

Here is a sample of code creating a promise:

```js
function createUser(user) {
	return new Promise((resolve, reject) => {
		doCreateUser(user, (err, result) => {
			if(err) {
				reject(err);
			} else {
				resolve(result);
			}
		});
	});
}
```

Here, we're only wrapping a call using callback into a function that returns a promise. Then the user can use our function:

```js
createUser(user)
  .then(result => display(result))
  .catch(err => displayError());
```

As soon as we're calling the `createUser()` function, the `doCreateUser()` function will be called.

```js
const promise = createUser(user);
```

That means that in this example of code, even if we don't use the returned promise (by calling `then` or `catch`), the `doCreateUser()` function will be called and perform its action. **Promises are not *lazy*.**

Another thing you need to know: promises can only be resolved once. Let's see what that means:

```js
function doSomething() {
  return new Promise((resolve, reject) => {
    resolve(1);
    resolve(2);
    reject(3);
  });
}

doSomething().then(onSuccess, onFailure);
```

Here, even if we try to resolve the promise a few more times (two times with success, one time with an error), the promise will only be resolved once with the success value `1`. As a consequence, `onSuccess` will be called once and exactly once with the value `1`. And `onFailure` will never be called.

This is an important guarantee: **your handler can *at most* be called once.** "At most" because you have no guarantee that your promise will ever be resolved, maybe it will forever stay in the *pending* state.

A last thing that seems important to notice is that promises are part of the ECMAScript specification since ES2015: it is part of the JavaScript standard library.

## Observables 

More than being boxes, observables are rather a pipe inside of which values are sent over the time. An observable can produce multiple values and not just one like promises. It can have several states: not started, started, on error or completed. When an observable is started, it can emit events at any moment. But as soon as the observable is completed or there is an error, the observable won't emit any event anymore.

<div style="text-align: center">    
    <img src="/images/observables.png" alt="Diagram of an observable states as described above" style="max-width: 100%;">    
</div>

Observables are not part of the ECMAScript specification for now. [There is a proposal](https://github.com/tc39/proposal-observable) that hasn't moved much the last years and is stuck at stage 1. So when we're talking about observables in JavaScript, we are mainly talking about the JavaScript implementation of the [Reactive Extensions](http://reactivex.io/), available under the name [RxJS](https://rxjs.dev/). For example, Angular uses RxJS a lot since its version 2.

RxJS is based on observable streams but adds a layer of operators to handle those streams. These many operators are really useful to transform the data but can be confusing at first and are not part of the initial Observable paradigm. I'd need a whole article only to describe them, so let's focus on the observables themselves.
