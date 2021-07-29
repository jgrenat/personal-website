---
{
  "type": "blog",
  "author": "Jordane Grenat",
  "title": "Your Frontend User Stories are not Ready!",
  "description": "The web platform provides many ways to interact with each element. That's why it's so hard to include everything that is needed in your frontend user stories. This article gathers some commonly forgotten elements.",
  "image": "images/article-covers/frontend-us-readiness.jpg",
  "published": "2021-07-30",
}
---

Having worked in many teams and projects, when arriving at a new project, I almost always face the same issue: first User Stories that are created are never truly *ready*.

In my opinion, teams have several level of maturities during a project, and it's completely normal that things are not perfect at start. The team needs to learn how to work together.

Plus I'm convinced there is no universal answer to the question "When is this US ready?" Each team has its own expectations  and this will usually take several iterations to have a proper definition of ready. Of course, it will also evolve during time.

That being said, I do think there are many essential elements that are often missing from front-end US and I do want to talk about them.

## User interaction

It's really easy to forget to showcase user interactions on a mockup. How an element behaves when hovered by a user for example. Having a distinct style increases the click affordance and can make the difference between a confusing interface and a more intuitive one. Be sure to collaborate with the UX / UI designers on that.

Also, don't forget to handle the focus. Users can use their keyboard to navigate in a page, either by preference or because they can't use a mouse. Giving a visible focus style to your element make it (more) accessible.

In fact, I'm talking here about all relevant states of an element. For example, if you're using drap'n'drop somewhere, you need to know how to represent the dragged element. Some approaches like building a design system may help you remember to handle those states.

## Sad path

When something can fail, you need to know how to handle the error. When you make an API call for example, it is very likely that this call will fail at some point.

If we are fetching some data to display, what should we display instead? If the user was trying to perform an action, how can we interpret the failure to display a meaningful error message? How is this message styled? Or maybe we can recover from the error by doing something else or performing an automatic retry?

Let's take an example: a single field where the user can type its email address to subscribe to a newsletter. The email format can be invalid: how can we display this error to the user? Once validated, the user may have lost network connection, how can we indicate that? Or maybe the call can fail server-side, either because there is a random error, or because the user is already registered. In this last case, should we display an error to the user? Or maybe confirm the subscription without notifying that he was already registered? This is a business decision, not only a technical one.

The sad path is something really easy to forget, leading to interfaces that seems broken or not responding, which can cause a lot of frustration to your users.

## Empty states

Even when there is no error, some calls may return empty results. For example, when fetching a list of favorites movies for a user, it is really likely that it won't contain anything when the user has just registered.

Instead of having a blank screen, it's better to have a message so that the user doesn't think there is something broken.

Moreover, empty states are a great opportunity to provide specific information to the user. In this particular example, maybe the user don't know how to add favorite movies? Replacing the empty screen with guidance may be the move to improve your user experience.

Sometimes, you have temporary empty states, for example when you're loading the data or performing an action. Be sure to know how your UI hint that something is in progress.

## Images

Some images are only there for decoration and should not contain an alternative text and should be hidden from screen readers. Other images are mandatory to understand the context. In this case, be sure to provide a proper alternative text. To consider a user story as ready, there should be no confusion whether an image belongs to the first or the second category.

User-contributed images are also quite tricky to display: they can have various proportions, so there needs to be a rule of how to handle its display: should we have a max/min width, a max/min height? Both? If there are size constraints, how should the [image be resized to fit its container](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit)?

## Forms

Be sure the US specify all validation-related specifications for your forms: maxlength, required, minlength, patterns.

The mockups must have an example of a field with an error, and if necessary, a disabeld field and a global form error (for errors that are not linked to a specific field).

## Browser support

This part is a project-wide guideline. I've seen many projects where the browser support is not specified anywhere. Do we need to support legacy browsers? (IE 11 😱) If the answer is yes, is it some kind of *best-effort* support – meaning the experience can be gracefully degraded?

The answer to these questions may impact many decisions on the front-end part, so this is something that is better addressed early in the project.

## Conclusion

The frontend ecosystem covers a wide area. You have a large variety of users – audience, search engine crawlers, screen readers, ... – a large variety of devices, and many interactions to handle.

No wonder that you can (and will) forget some aspects, but hopefully this list will serve as a bridge tower better user stories (and therefore better websites!)
