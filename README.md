# Everest Coding Challenge: Package Delivery

This README serves as a documentation of the thought process taken while setting up and developing this flow.


## Starting out

There were several options to kick start this project and since using Swift to develop a command line tool is a rare scenario, documentation on the idea has been limited but it boils down to the following options:

1. Creating an executable using Swift Package Manager according to this [Swift document](https://www.swift.org/getting-started/cli-swiftpm/) which would allow all developers to run this code as long as Swift is installed in their machine
2. Use the conventional way of XCode Project to create a MacOS Command Line Tool but with this approach only users with XCode will be able to run this code.

After a few trials and errors, I ended up using option #2 as this was the only way I was able to get a unit test target running in order to follow TDD practices. Option #1 required all business logic to be segreated into a framework and have the command line executable depend on it, but for the context of this assignment, I would prefer to keep things simple.

## Problem 1

### Assumptions:

1. All distance and weights are all positive numbers.
2. Decimals are fair game, e.g. if a 5% discount ends up with decimals like $5.7123, it would be fair to display rounded numbers into the nearest ten-cent which is $5.70. Idea came from a business perspective where customers would not want to be charged an extra $0.30 and the business should not lose $0.70.
3. The first line is critical metadata (base weight and no. of packages) that should be accurate to continue the business logic, hence there should be a way to retain it while the program runs, and also to ensure its accuracy. This should be a reversible error that the customer should be able to correct.
4. There will be a model that mimicks all the information from the Offer table in the PDF document. The business logic should have a dictionary of this structure with the OfferID as the key.
5. There will also be a model that stores the package information from the user input.
6. There will be a class that checks if discount is applicable, and if yes, return the discount amount. Ideally, the Offer dictionary should reside in this class.
7. All data to live in memory i.e. no caching into text file
8. Will need a `readLine()` function in a `while-loop` to keep the program waiting for input until all packages are accounted for