# Elm-Auth
An example of how to deal with authentication without nesting tokens. 
This example is extremely verbose so you don't really need to go to
deep in Elmland up to understand it.


## Running
```bash
npm install -g elm
elm-package install
elm-reactor
```
Then just go to ```Main.elm``` and try out the form.


Username is **test**

password is **password**

## Lenses vs TEA
Lenses (CoState CoMonads) are generally used to change or retrieve values
tersely within large nested structures. In the case of Elm, these
structures may be considered an anti pattern in that the elm runtime
itself is almost a State Monad Transformer.

The reasoning behind my thinking is that The Elm Architecture best practices
involve creating self relient components on a top level where global state
should be handled by the highest level component.

In this case, for our frontend to recognize that it has an authentication
token, instead of checking both a potential login component and register
component for the same token, we can easily place the token within
the toplevel state so that any potential module could have access to it.

In terms of nested records in Elm, the boilerplate can be a pain but
we also need to remember that we can change the pattern itself.

Elm is not Haskell, Elm doesn't need to deal with the kernel, or IO
for that matter as that is all handled by the browser and Elm runtime.


## FAQ

**Where are the routes?**

This is a very terse example of the child - parent pattern.
I can add routes to this project later when I have time if an issue is made for it.


**What if I have a component I want to drag around and depending on where it is something could happen I.E a chess piece?**

Well again maybe the pattern is wrong, records aren't the best idea for every problem, and I'm not saying lenses within
Elm are the worst thing in the world, but in terms of large code bases over multiple modules, they may not be the best idea.

You could handle this problem with an ADT (union type) say:
```Elm
type ChessPiece = ChessPiece Maybe(Rank File Piece)

getCP : ChessPiece -> Maybe(Rank File Piece)
getCP (ChessPiece mayb) = mayb
```
This involves a whole lot less boilerlate than record syntax, and since a piece could have been taken,
it may be easier to use a Maybe within that type and just use fmap (Maybe.map in Elm). Similar to lenses.

Then again, maybe modifying the piece position could happen with a ChessPiece update function.
All I'm doing is showing a pattern I prefer to use when other child models need information from another child model.

**What if I don't use JWTs and instead use server side session for user authentication?**

Well that's an issue everyone has with a functional frontend language. I tend to prefer
two server routes, one for auth, with a good 200 request just have the app change the url to the next authenticated route.
Maybe have the server redirect if they're not logged in to the Auth elm page depending on what we're doing.
