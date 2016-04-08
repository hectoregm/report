describe("C3.model.Recommendation", function() {
    var instance;

    beforeEach(function() {
        instance = new C3.model.Recommendation({

        });
    });

    describe("validating state transitions", function() {
        describe("from a available state", function() {
            beforeEach(function() {
                instance.set('userAction', 'available');
            });

            it("should allow a transition to added", function() {
                expect(instance.validateTransition('added')).toBeTruthy();
            });

            it("should allow a transition to not applicable", function() {
                expect(instance.validateTransition('notApplicable')).toBeTruthy();
            });

            it("should not allow a transition to available", function() {
                expect(instance.validateTransition('available')).toBeFalsy();
            });

            it("should not allow a transition to complete", function() {
                expect(instance.validateTransition('complete')).toBeFalsy();
            });
        });
    });
});