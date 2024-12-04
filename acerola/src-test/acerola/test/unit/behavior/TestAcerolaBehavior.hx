package acerola.test.unit.behavior;

import utest.Assert;
import acerola.server.behavior.AcerolaBehavior;
import acerola.server.behavior.AcerolaBehaviorManager;
import utest.Test;

class TestAcerolaBehavior extends Test {
    
    function test_behavior_manager_should_register_and_return_correct_behavior_instance() {
        // ARRANGE
        var manager = new AcerolaBehaviorManager(null, null);

        var expectedName1:String = 'behavior1';
        var resultName1:String;

        var expectedName2:String = 'behavior2';
        var resultName2:String;

        // ACT
        manager.addBehavior(AcerolaBehavior1);
        manager.addBehavior(AcerolaBehavior2);

        resultName1 = manager.get(AcerolaBehavior1).name1;
        resultName2 = manager.get(AcerolaBehavior2).name2;

        // ASSERT
        Assert.equals(expectedName1, resultName1);
        Assert.equals(expectedName2, resultName2);
    }
}

private class AcerolaBehavior1 extends AcerolaBehavior {
    public var name1:String = 'behavior1';
}

private class AcerolaBehavior2 extends AcerolaBehavior {
    public var name2:String = 'behavior2';
}