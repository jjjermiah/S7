describe("greet()", {
    it("returns a greeting message", {
        expect_equal(greet("Alice"), "Hello, Alice!")
        expect_equal(greet("Bob"), "Hello, Bob!")
    })
})