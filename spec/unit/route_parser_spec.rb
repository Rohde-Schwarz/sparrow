require 'spec_helper'

module CamelCaser
  describe RouteParser, type: :unit do
    describe '#excluded routes' do
      it 'should default to the excluded routes from the configuration' do

      end

      it 'should be set to the value given in the constructor as regexes' do
        expected = [/panda/, /bamboo/]
        actual = RouteParser.new(expected).excluded_routes
        expect(actual).to eq expected
      end
    end

    describe '#exclude?' do
      it 'should return true if the path is in the excluded routes' do
        path = '/panda'
        route_parser = RouteParser.new(['panda'])
        expect(route_parser.exclude?(path)).to eq true
      end

      it 'should return false if the path is not in the excluded routes' do
        path = '/panda'
        route_parser = RouteParser.new([])
        expect(route_parser.exclude?(path)).to eq false
      end
    end

    describe '#allow?' do
      it 'should return false if the path is in the excluded routes' do
        path = '/panda'
        route_parser = RouteParser.new(['panda'])
        expect(route_parser.allow?(path)).to eq false
      end

      it 'should return true if the path is not in the excluded routes' do
        path = '/panda'
        route_parser = RouteParser.new([])
        expect(route_parser.allow?(path)).to eq true
      end
    end
  end
end