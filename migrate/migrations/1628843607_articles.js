'use strict';

import {unified}  from 'unified';
import {toHast} from 'mdast-util-to-hast';
import parse from 'remark-parse';
import { hastToStructuredText } from 'datocms-html-to-structured-text';
import { validate } from 'datocms-structured-text-utils';
import {inspect} from 'unist-util-inspect';
import {SiteClient} from 'datocms-client'

const TOKEN = '959f39ae53385fc30ac5e64c4fdcf1';

const datocmsClient = new SiteClient(TOKEN)

async function markdownToStructuredText(text, settings) {
  const mdastTree = unified().use(parse).parse(text);
  const hastTree = toHast(mdastTree);
  const result = await hastToStructuredText(hastTree, settings);
  const validationResult = validate(result);
  if (!validationResult.valid) {
    console.log(inspect(result));
    throw new Error(validationResult.message);
  }
  return result;
}

(async function() {
  const modelId = await findModelId('article', datocmsClient);
  const content = await markdownToStructuredText(contentString);

  return datocmsClient.items
    .create({
      itemType: modelId,
      name: {fr: 'Time is money. Which one do you value the most?'},
      slug: {fr: 'time-money-life'},
      banner: {uploadId: '21207426'},
      content: {fr: content}
    })
    .then(savedPointOfInterest =>
        console.log('saved')
      , console.error)
})();



async function findModelId(apiKey, datocmsClient) {
  const model = await datocmsClient.itemTypes.find(apiKey)
  return model.id
}

var contentString = `> Disclaimer: I have few notions in economics ; the concepts and ideas described in this article are only the fruits of my reflection. Maybe some of them will appear naive, maybe not. It has been a really difficult subject for me to write about and I hope I've been able to express myself properly. Either way, I'd love to discuss it with you on [Twitter](https://twitter.com/JoGrenat)! 🙂
 
As Benjamin Franklin said, **time is money**. I've used this proverb many times without realizing how true it was. Or maybe not, because time is in fact not money, but rather a **currency**. 

This is a pretty strange one, by the way. We all receive a specific and unknown amount of time that we will spend as we wish during our life. This number cannot be increased (yet?). Once you've used some seconds, you cannot get them back. Let me rephrase that: whenever you spend time doing something, your time wealth decreases. You are **investing** your time in this activity.

Now this very much looks like a bullshit inspirational article. Bear with me, this introduction was somewhat necessary for what follows.

As I said, this is a weird currency. You can exchange time for what you want. You want to eat a nice omelet? Spend some time and cook it! You don't have eggs? Capture a chicken, raise it and wait until it lays eggs! Wow, that sounds quite impractical and very **time expensive**!

## Time and Money

Time is a currency that is sometimes hard to trade for what you want. Fortunately, here comes **money**! Money is another currency that is far more easy to trade for everything you need or want. You don't need to raise a chicken, you only need to buy eggs from someone who raises chickens! Now you start to understand where I'm leading you: we need to trade time for money.

This is the exact definition of a job: you give your time to a company (or your own company) in exchange for money. That money will then allow you to get most of the things you want if you have enough of it. 

You invest a part of your time wealth into money to be able to live and to get comfort. This is what a job is: a support function allowing you to survive and enjoy the rest of your time. **The important part of your life is this free time**, not the time you spend working for money. 

When you work, you earn a salary (or if you work on your own, you earn money directly). That amount of money represents something: **this is what your time is worth**. If someone is paid more, that means his or her time produces more money, leading to the awful conclusion that some people's time is valued more than others'. This is wrong at so many levels! I think we have a lot to do as humans to fix this...

These are the two main ideas I want to highlight: you trade a part of your time to support the time you enjoy and that time has an exchange rate depending on your skills and your luck (which part is the biggest, I'll let you decide...).  

Working for someone else means that you're spending your time in order to get money. This time is not yours anymore. Or is it? If you have a job you like (or even love), you win a part of that time back. Unfortunately, not everyone is able to be in this situation.

Money is useful while you need it to sustain your life. Once you've got enough money, why would you trade more time for money instead of enjoying that time? I feel like this is the part where I'm being naive, as nobody seems to think like that. Having more and more money seems to have become the main goal in life.

Former french president Nicolas Sarkozy, has been famous for this quote: "work more, earn more". This is somewhat true: working more time means you trade more time for money. But that time is then lost to you!

Maybe the real objective is to get more money within less time? Then you need to have a higher salary without working more, until maybe you win enough to reduce your time spent working? This is easy to say, hard to accomplish and really dependent on your context.

## Money and Money

But time is not the only way to get money. Some people don't need to invest time to earn it. Maybe they have wealthy relatives, or maybe they won the lottery... Nobody is born equal, meaning that this system can't be fair.

There is something else that you need to take into consideration: **money can produce money**! If you have enough money, it can produce more money! If it produces enough money to sustain your needs, then you don't need to trade time anymore and you can enjoy your whole lifetime. 

For example, if you invest some of your time in building a company and at some point you don't need to spend time anymore for the business to work, then you have achieved something: you are now paying other people (employees, partners, ...) to spend time on something that will bring you more money than the amount you've just spent. Money without (your) time.

That is quite the same with market shares (with a lot of intermediary steps and many unethical facts in-between) or when you buy something to generate money (such as a house that you will lend or sell at a higher price). 

You don't need time for any of these options. You can pay a rental agency to handle all the paperwork for the house you're renting out. Or you can pay employees to work for your company. Finally you can buy market shares once and then receive dividends.

In any of those examples, you have taken **your** time out of the equation. But at the end of the day, *someone* will invest her or his own time to produce money that you will then earn. This person is likely to have a lesser valued time than yours. Once again, this is unfair. 

## Time, Money and Life

Despite the fact that I love my job, I consider that work is not the important part of my life. As humans, we should aim to remove labor as much as possible and automatize everything we can. If a task is boring and can be done by a machine, why should we bother doing it? 

So why isn't it the case? Why do people protest when jobs are removed to be replaced by machines? Because nowadays, *work* is mandatory to live. If you don't have a job, you cannot sustain your life. So instead of reducing manual work load, we're trying to reduce unemployment rate! Why is being jobless so often frowned upon? Unemployment has somewhat become *bad*. 

How crazy is that? The fact is: we need money to live. And we need a job or money to earn money. This situation is broken and won't fix itself unless we try to change the system itself. So what are the solutions?

The one that comes to my mind is **universal income**. The idea is that living a decent life is a human right and everybody should receive enough money to live each month, independently of whether people are working or not. That base income can then be increased if you work, giving you access to more comfort. Work would not be mandatory to survive, but necessary to get a better life. 

The universal income as I've described it seems like a dream and I am aware there are many nuances and potential issues to solve before this kind of system can work. As I've said earlier, I have too few notions in economics to apprehend all the implications of it. Let's say this is too ambitious for now and move on to other solutions.

Let's say universal income is not coming in a near future and let's look at how we can improve things right now. If the unemployment rate is too high, we could reduce the working time. Target 25 hours a week (random number) and hire people to compensate. Currently, the standard work-life balance is 5 days spent working and 2 days spent *living*. Or let's say the equivalent of 4 days spent working and 3 days spent living if you want to take into consideration mornings and evenings. Either way, I don't want to keep this ratio my entire life!

So where does all of this lead us? I'm not sure and I certainly don't have any answers for you. I'm just starting to realize that a lot of things are wrong and that nobody in charge has any reason to change the current system. It advantages people who already have everything they need and let others waste their time wealth for just a small amount of money. 

These days, in the context of the COVID-19, we're talking a lot about the *world of tomorrow*. Being quite lucky compared to other people, I was able to reduce my working time a few months ago and I will continue to do so. 

But as a whole, I feel like we have not really improved in decades. I fear that the *world of tomorrow* will be the same as the *world of yesterday*, **[a world where this amazing website conveys an unspeakable truth](https://mkorostoff.github.io/1-pixel-wealth/)**. 

> This is the current state of my reflections, and I'd be very interested in hearing yours. [Let's talk?](https://twitter.com/JoGrenat)

<p class="thanks">Many thanks to <a href="https://www.linkedin.com/in/alexabts">Alexandre Abrantes</a> and <a href="https://berthelot.io/">Florent Berthelot</a> for their very helpful reviews!</p>
`
