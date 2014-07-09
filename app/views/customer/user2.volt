<?php
use Phalcon\Tag as Tag;

?>

{{content()}}

<div ng-app="customInterpolationApp" ng-controller="UserListCtrl">


    <div class="panel panel-default">
        <div class="panel-heading">
            <h3>{{customer.Name}}：
                <small>用户列表</small>
                {{ link_to('customer/createuser', '<i class="glyphicon glyphicon-check"></i>添加', "class":"btn btn-link
                pull-right" ) }}
            </h3>
        </div>

        <table class="table table-bordered table-striped">
            <thead>
            <tr>
                <th>#</th>
                <th>用户名称</th>
                <th>加入时间</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>

            <tr ng-repeat="user in users | orderBy:'Sort'">
                <td>{$ $index+1 $}</td>
                <td>{$ user.Name $}</td>
                <td>{$ user.CreateTime $}</td>
                <td>
                    <input type="checkbox" ng-change="test(user)" ng-model="user.Type">
                </td>
                <td width="12%">
                    <a ng-click="up(user)">上</a>
                    <a ng-click="down(user)">下</a>
                    <a class="btn-default" ng-click="edit(user)"><i class="glyphicon glyphicon-edit"></i></a>
                    <a class="btn-default" ng-click="remove(user)"><i class="glyphicon glyphicon-remove"></i></a>
                </td>
            </tr>

            </tbody>
        </table>

    </div>

    <say-time></say-time>
    <div id="myModal" class="modal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header" draggable>
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="myModalLabel">编辑用户</h4>
                </div>
                <div class="modal-body">
                    {{ form('customer/createuser', 'method': 'post', 'role':'form') }}
                    <div class="form-group">
                        <label for="exampleInputEmail1">用户名</label>
                        {{ text_field("Name", "size": 32, "value":"{$ cu.Name $}", "ng-model":"cu.Name", "class":"form-control") }}
                    </div>
                    <div class="form-group">
                        <label for="exampleInputPassword1ww">密码</label>
                        {{ password_field("Password", "size": 32, "ng-model":"cu.Pass", "class":"form-control") }}

                    </div>
                    <div class="form-group">
                        <label for="exampleInputFile">选择管理酒店</label>
                        {{ password_field("Desc", "size": 32, "class":"form-control") }}
                    </div>

                    {{ end_form() }}

                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-success" ng-click="submit()" >提交</button>
                    <button type="cancel" class="btn btn-default pull-right" data-dismiss="modal">取消</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->

    </div>
    <!-- /.modal -->
</div>

{{ javascript_include('js/angular.min.js') }}

<script>

    var app = angular.module('customInterpolationApp', []);
    app.config(function ($interpolateProvider) {
        $interpolateProvider.startSymbol('{$');
        $interpolateProvider.endSymbol('$}');
    });

    function UserListCtrl($scope, $http) {
        $scope.cu = {};

        $http.get('/h/customer/userlist').success(function (data) {
            $scope.users = data;
        });

        $scope.edit = function (user) {
            angular.copy(user, $scope.cu);
            $('#myModal').modal({})
        }

        $scope.remove = function (user) {
            confirm("删除" + user.Name);
        }

        $scope.up =function(user){
            user.Sort += 1;
        }

        $scope.submit = function(){
            $http.post('/h/customer/createuser', $scope.cu).success(function (data) {
                alert(data);
            });
        }
    }

    //UserListCtrl.$inject = ['$scope', '$http'];

    app.directive('sayTime', function ($interval, dateFilter) {

        function link(scope, element, attrs) {
            var format = 'yyyy-MM-dd HH:mm:ss';
            var timeoutId;
            function updateTime() {
                element.text(dateFilter(new Date(), format));
            }
            element.on('$destroy', function() {
                $interval.cancel(timeoutId);
            });

            timeoutId = $interval(function() {
                updateTime(); // update DOM
            }, 1000);
        }

        return {
            restrict : 'E',
            link: link
        };
    });

    app.directive('draggable', function ($document) {
        var startX = 0, startY = 0, x = 0, y = 0;

        return function (scope, element, attr) {
            var container = $("#myModal");

            container.css({
                position: 'absolute',
                overflow: 'hidden'
            });

            element.bind('mousedown', function (event) {
                startX = event.screenX - x;
                startY = event.screenY - y;
                $document.bind('mousemove', mousemove);
                $document.bind('mouseup', mouseup);
            });

            function mousemove(event) {
                y = event.screenY - startY;
                x = event.screenX - startX;
                container.css({
                    top: y + 'px',
                    left: x + 'px'
                });
            }

            function mouseup() {
                $document.unbind('mousemove', mousemove);
                $document.unbind('mouseup', mouseup);
            }
        }
    });

</script>