# lazy_crud
Lazy way to implement common actions in controllers in Rails

[![docs](https://img.shields.io/badge/docs-yardoc-blue.svg?style=flat-square)](http://www.rubydoc.info/github/NullVoxPopuli/lazy_crud)
[![Gem Version](http://img.shields.io/gem/v/lazy_crud.svg?style=flat-square)](http://badge.fury.io/rb/lazy_crud)
[![Build Status](http://img.shields.io/travis/NullVoxPopuli/lazy_crud.svg?style=flat-square)](https://travis-ci.org/NullVoxPopuli/lazy_crud)
[![Code Climate](http://img.shields.io/codeclimate/github/NullVoxPopuli/lazy_crud.svg?style=flat-square)](https://codeclimate.com/github/NullVoxPopuli/lazy_crud)
[![Test Coverage](http://img.shields.io/codeclimate/coverage/github/NullVoxPopuli/lazy_crud.svg?style=flat-square)](https://codeclimate.com/github/NullVoxPopuli/lazy_crud)
[![Dependency Status](http://img.shields.io/gemnasium/NullVoxPopuli/lazy_crud.svg?style=flat-square)](https://gemnasium.com/NullVoxPopuli/lazy_crud)


## Features

 - Minimal Controller Coding
 - Resource Can be Scoped to Parent Resource

### TODO

 - Generic Error Handeling
 - i18n
 - lambdas and procs for inserting custom behavior

## Installation

Gemfile

    gem 'lazy_crud'

Terminal

    gem install lazy_crud

## Configuration


### Basic setup

    class SomeObjectController < ApplicationController
      include LazyCrud

      # At a bare minimum, you'll need to specify the
      # class the controller is acting upon.
      set_resource SomeObject

      # optional
      # this is for in the case of you having nested routes, and want to scope
      # SomeObject to its parent object.
      # For example: /event/:event_id/discounts/:id
      # Event is the parent object and Discount is the resource
      #
      # Note that there must be an @event instance variable set
      #
      # See specs for details
      set_resource_parent Event

      # sort of optional
      # if you want to be able to update / create objects, you'll want to
      # specify what parameters are allowed to be set.
      # this uses strong parameters
      set_param_whitelist(:name, :amount)
    end

## Contributing

1. Fork the project
2. Create a new, descriptively named branch
3. Add Test(s)!
4. Commit your proposed changes
5. Submit a pull request
