angular.module 'quest-config', []

#config ($compileProvider) ->
#  $compileProvider.debugInfoEnabled(false)

.config ->
  unless String.prototype.contains
    String.prototype.contains = ->
      ///#{arguments[0] || ''}///i.test this

  unless String.prototype.containsAll
    String.prototype.containsAll = ->
      for search in (arguments[0] || '').split ' '
        return false unless ///#{search}///i.test this
      return true

.config ($httpProvider, $compileProvider) ->
  errorElements = []

  $compileProvider.directive 'httpErrors', ->
    link: (scope, element) ->
      errorElements.push element
      scope.$on '$stateChangeStart', ->
        for element in errorElements
          element.html('').removeClass('alert alert-danger')

  $httpProvider.interceptors.push ($q) ->
    response: (successResponse) ->
      successResponse
    responseError: (errorResponse) ->
      reason = errorResponse.headers('reason') || ''
      for element in errorElements
        element.html(reason).addClass('alert alert-danger')
      $q.reject(errorResponse)

  $httpProvider.defaults.cache = true

#.controller 'config' , class
#  constructor: ($rootScope) ->
#    $rootScope.datatableDom:'Bftlip'