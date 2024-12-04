package acerola.test.unit;

import acerola.test.unit.request.TestAcerolaRequest;
import utest.ui.Report;
import utest.Runner;

class AcerolaUnitTestJs {
    
    static public function main() {

        var runner = new Runner();

        runner.addCase(new TestAcerolaRequest());
        
        Report.create(runner);
        runner.run();
        
    }

}