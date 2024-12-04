package acerola.test.unit.path;

import acerola.request.AcerolaPath;
import utest.Assert;
import utest.Test;

class AcerolaPathTest extends Test {
    
    function test_route_with_no_params() {
        // ARRANGE
        var path:AcerolaPath = '/foo/bar';
        var expected:String = '/foo/bar';

        // ACT
        var result:String = path.cleanPath;

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_route_with_int_param() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[id:Int]';
        var expected:String = '/foo/:id';

        // ACT
        var result:String = path.cleanPath;

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_route_types_map_object_int_and_string() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        var expectedName:String = "String";
        var expectedId:String = "Int";
        
        // ACT
        var resultTypes = path.types;

        // ASSERT
        Assert.equals(expectedName, resultTypes.get('name'));
        Assert.equals(expectedId, resultTypes.get('id'));
    }

    function test_acerola_path_should_generate_path_with_values() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        var values:Dynamic = {
            name : "bar",
            id : 1
        };
        var expected:String = '/foo/bar/1';

        // ACT
        var result:String = path.parse(values);

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_acerola_path_should_generate_path_with_values_and_utfstring() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        var values:Dynamic = {
            name : "maçã",
            id : 1
        };
        var expected:String = '/foo/ma%C3%A7%C3%A3/1';

        // ACT
        var result:String = path.parse(values);

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_acerola_path_should_generate_path_with_value_missing() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        var values:Dynamic = {
            id : 1
        };
        var expected:String = '/foo//1';

        // ACT
        var result:String = path.parse(values);

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_acerola_path_should_generate_clean_data_from_common_object() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        
        var values:Dynamic = {
            name : "bar",
            id : "1"
        };

        var expected:Dynamic = {
            name : "bar",
            id : 1
        };

        // ACT
        var result:Dynamic = path.extractCleanData(values);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_acerola_path_should_generate_clean_data_from_common_object_with_null_elements() {
        // ARRANGE
        var path:AcerolaPath = '/foo/[name:String]/[id:Int]';
        
        var values:Dynamic = {
            id : "1"
        };

        var expected:Dynamic = {
            name : null,
            id : 1
        };

        // ACT
        var result:Dynamic = path.extractCleanData(values);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_acerola_path_should_generate_null_data_route_without_params() {
        // ARRANGE
        var path:AcerolaPath = '/foo/bar';
        
        var values:Dynamic = {};
        
        var expected:Dynamic = null;

        // ACT
        var result:Dynamic = path.extractCleanData(values);

        // ASSERT
        Assert.same(expected, result);
    }
}