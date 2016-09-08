/**
 * qing-timepicker v1.0.0
 * http://mycolorway.github.io/qing-timepicker
 *
 * Copyright Mycolorway Design
 * Released under the MIT license
 * http://mycolorway.github.io/qing-timepicker/license.html
 *
 * Date: 2016-09-8
 */
;(function(root, factory) {
  if (typeof module === 'object' && module.exports) {
    module.exports = factory(require('jquery'),require('moment'),require('qing-module'));
  } else {
    root.QingTimepicker = factory(root.jQuery,root.QingModule);
  }
}(this, function ($,QingModule) {
var define, module, exports;
var b = require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Input,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Input = (function(superClass) {
  extend(Input, superClass);

  Input.opts = {
    wrapper: null,
    showHour: true,
    showMinute: true,
    showSecond: true,
    placeholder: ''
  };

  function Input(opts) {
    Input.__super__.constructor.apply(this, arguments);
    this.opts = $.extend({}, Input.opts, this.opts);
    this.wrapper = $(this.opts.wrapper);
    this.active = false;
    this._render();
    if (this.opts.showHour) {
      this._renderItem('hour');
    }
    if (this.opts.showMinute) {
      this._renderItem('minute');
    }
    if (this.opts.showSecond) {
      this._renderItem('second');
    }
    this._bind();
  }

  Input.prototype._render = function() {
    this.el = $('<div class="input"></div>');
    this.el.append("<div class='placeholder'>" + this.opts.placeholder + "</div>");
    this.itemWrapper = $('<ul class="item-wrapper"></ul>').appendTo(this.el);
    return this.el.appendTo(this.wrapper);
  };

  Input.prototype._renderItem = function(type) {
    return $('<li class="item"><span class="value"></span></li>').attr('data-type', type).appendTo(this.itemWrapper);
  };

  Input.prototype._bind = function() {
    return this.el.on('click', (function(_this) {
      return function(e) {
        return _this.trigger('click');
      };
    })(this));
  };

  Input.prototype.setValue = function(time) {
    if (time) {
      ['hour', 'minute', 'second'].forEach((function(_this) {
        return function(type) {
          return _this._setItemValue(type, time);
        };
      })(this));
      return this.el.addClass('selected');
    } else {
      return this.el.removeClass('selected');
    }
  };

  Input.prototype._setItemValue = function(type, time) {
    return this.itemWrapper.find(".item[data-type='" + type + "'] .value").text(this._parseItemValue(time[type]()));
  };

  Input.prototype.setActive = function(active) {
    this.active = active;
    this.el.toggleClass('active', active);
    return this.active;
  };

  Input.prototype.highlight = function(type) {
    this.removeHighlight();
    return this.itemWrapper.find(".item[data-type='" + type + "'] .value").addClass('highlight');
  };

  Input.prototype.removeHighlight = function() {
    return this.itemWrapper.find('.value.highlight').removeClass('highlight');
  };

  Input.prototype._parseItemValue = function(value) {
    if (value < 10) {
      return "0" + value;
    } else {
      return value.toString();
    }
  };

  Input.prototype.destroy = function() {
    return this.el.remove();
  };

  return Input;

})(QingModule);

module.exports = Input;

},{}],2:[function(require,module,exports){
var Popover, SelectView,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

SelectView = require('./select-view.coffee');

Popover = (function(superClass) {
  extend(Popover, superClass);

  Popover.opts = {
    wrapper: null,
    showHour: true,
    showMinute: true,
    showSecond: true
  };

  function Popover(opts) {
    this.setTime = bind(this.setTime, this);
    Popover.__super__.constructor.apply(this, arguments);
    this.opts = $.extend({}, Popover.opts, this.opts);
    this.wrapper = $(this.opts.wrapper);
    this.active = false;
    this.selectors = [];
    this._render();
    this._initChildComponents();
    this._bind();
  }

  Popover.prototype._render = function() {
    return this.el = $('<div class="popover"></div>').appendTo(this.wrapper);
  };

  Popover.prototype._initChildComponents = function() {
    if (this.opts.showHour) {
      this._initSelectView('hour');
    }
    if (this.opts.showMinute) {
      this._initSelectView('minute');
    }
    if (this.opts.showSecond) {
      return this._initSelectView('second');
    }
  };

  Popover.prototype._initSelectView = function(type) {
    return this.selectors.push(new SelectView({
      wrapper: this.el,
      type: type
    }));
  };

  Popover.prototype._bind = function() {
    this.selectors.forEach((function(_this) {
      return function(selector) {
        return selector.on('hover', function(e, type) {
          return _this.trigger('hover', [type]);
        }).on('select', function(e, type, value) {
          _this.time[type](parseInt(value, 10));
          return _this.trigger('select', _this.time);
        });
      };
    })(this));
    return this.el.on('mouseout', (function(_this) {
      return function(e) {
        _this.trigger('mouseout');
        return e.stopImmediatePropagation();
      };
    })(this));
  };

  Popover.prototype.setTime = function(time) {
    if (!this.time || !this.time.isSame(time)) {
      this.time = time;
      return this.selectors.forEach((function(_this) {
        return function(selector) {
          return selector.select(_this.time[selector.type]());
        };
      })(this));
    }
  };

  Popover.prototype.setActive = function(active) {
    this.active = active;
    this.el.toggleClass('active', active);
    if (this.active) {
      this.trigger('show');
      this.selectors.forEach(function(selector) {
        return selector.scrollToSelected();
      });
    } else {
      this.trigger('hide');
    }
    return this.active;
  };

  Popover.prototype.setPosition = function(position) {
    return this.el.css({
      top: position.top,
      left: position.left || 0
    });
  };

  return Popover;

})(QingModule);

module.exports = Popover;

},{"./select-view.coffee":3}],3:[function(require,module,exports){
var SelectView,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

SelectView = (function(superClass) {
  extend(SelectView, superClass);

  SelectView.opts = {
    wrapper: null,
    selectedIndex: 0,
    type: 'hour'
  };

  function SelectView(opts) {
    SelectView.__super__.constructor.apply(this, arguments);
    this.opts = $.extend({}, SelectView.opts, this.opts);
    this.wrapper = $(this.opts.wrapper);
    this.type = this.opts.type;
    this.items = this._generateItems();
    this._render();
    this._renderList();
    this._bind();
  }

  SelectView.prototype._render = function() {
    return this.el = $('<div class="select-view"></div>').appendTo(this.wrapper);
  };

  SelectView.prototype._renderList = function() {
    this.list = $('<ul></ul>');
    this.list.append(this.items.map(function(item, index) {
      return "<li>" + item + "</li>";
    }));
    return this.list.appendTo(this.el);
  };

  SelectView.prototype._bind = function() {
    return this.list.on('mouseover', 'li', (function(_this) {
      return function(e) {
        _this.trigger('hover', [_this.type]);
        return e.stopImmediatePropagation();
      };
    })(this)).on('click', 'li', (function(_this) {
      return function(e) {
        var value;
        value = $(e.currentTarget).text();
        _this.select(value);
        _this.trigger('select', [_this.type, value]);
        return _this.scrollToSelected(120);
      };
    })(this));
  };

  SelectView.prototype._generateItems = function() {
    var i, length, results;
    length = this.type === 'hour' ? 24 : 60;
    return (function() {
      results = [];
      for (var i = 0; 0 <= length ? i < length : i > length; 0 <= length ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this).map((function(_this) {
      return function(item) {
        return _this._parseValue(item);
      };
    })(this));
  };

  SelectView.prototype.select = function(value) {
    value = this._parseValue(value);
    if (this.selectedValue !== value) {
      this.selectedValue = value;
      this.selectedItem = this.list.find('li').get(this.items.indexOf(value));
      this.list.find('li.selected').removeClass('selected');
      return $(this.selectedItem).addClass('selected');
    }
  };

  SelectView.prototype._parseValue = function(value) {
    if (value < 10) {
      return "0" + value;
    } else {
      return value.toString();
    }
  };

  SelectView.prototype.scrollToSelected = function(duration) {
    if (this.selectedItem) {
      return this._scrollTo(this.el[0], this.selectedItem.offsetTop, duration);
    }
  };

  SelectView.prototype._scrollTo = function(el, to, duration) {
    var perTick;
    if (duration == null) {
      duration = 0;
    }
    if (duration <= 0) {
      return el.scrollTop = to;
    }
    perTick = (to - el.scrollTop) / duration * 10;
    return window.requestAnimationFrame((function(_this) {
      return function() {
        el.scrollTop = el.scrollTop + perTick;
        if (el.scrollTop !== to) {
          return _this._scrollTo(el, to, duration - 10);
        }
      };
    })(this));
  };

  return SelectView;

})(QingModule);

module.exports = SelectView;

},{}],"qing-timepicker":[function(require,module,exports){
var Input, Popover, QingTimepicker, extractChildComponentOpts,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Input = require('./input.coffee');

Popover = require('./popover.coffee');

QingTimepicker = (function(superClass) {
  extend(QingTimepicker, superClass);

  QingTimepicker.opts = {
    el: null,
    format: 'HH:mm:ss',
    renderer: null
  };

  QingTimepicker.count = 0;

  function QingTimepicker(opts) {
    QingTimepicker.__super__.constructor.apply(this, arguments);
    this.el = $(this.opts.el);
    if (!(this.el.length > 0)) {
      throw new Error('QingTimepicker: option el is required');
    }
    this.opts = $.extend({}, QingTimepicker.opts, this.opts);
    this.id = ++QingTimepicker.count;
    this._render();
    this._initChildComponents();
    this._bind();
    if ($.isFunction(this.opts.renderer)) {
      this.opts.renderer.call(this, this.wrapper, this);
    }
    this.setTime(moment(this.el.val(), this.opts.format, true));
  }

  QingTimepicker.prototype._render = function() {
    this.wrapper = $('<div class="qing-timepicker"></div>').data('qingTimepicker', this).insertBefore(this.el).append(this.el);
    this.clearButton = $('<a href="javascript:;" class="clear-button">x</a>').appendTo(this.wrapper);
    return this.el.hide().data('qingTimepicker', this);
  };

  QingTimepicker.prototype._initChildComponents = function() {
    var componentOpts;
    componentOpts = extractChildComponentOpts(this.opts.format);
    this.input = new Input($.extend({
      wrapper: this.wrapper,
      placeholder: this.opts.placeholder || this.el.attr('placeholder') || ''
    }, componentOpts));
    return this.popover = new Popover($.extend({
      wrapper: this.wrapper
    }, componentOpts));
  };

  QingTimepicker.prototype._bind = function() {
    $(document).on("click.qing-timepicker-" + this.id, (function(_this) {
      return function(e) {
        if ($.contains(_this.wrapper[0], e.target)) {
          return;
        }
        _this.popover.setActive(false);
        return _this.input.setActive(false);
      };
    })(this));
    this.input.on('click', (function(_this) {
      return function() {
        var ref;
        if (_this.popover.active) {
          _this.popover.setActive(false);
          return _this.input.setActive(false);
        } else {
          _this.popover.setTime(((ref = _this.time) != null ? ref.clone() : void 0) || moment());
          _this.popover.setActive(true);
          return _this.input.setActive(true);
        }
      };
    })(this));
    this.clearButton.on('click', (function(_this) {
      return function() {
        if (_this.popover.active) {
          _this.popover.setActive(false);
          _this.input.setActive(false);
        }
        _this.clear();
        return _this.trigger('clear');
      };
    })(this));
    return this.popover.on('show', (function(_this) {
      return function(e) {
        return _this.popover.setPosition({
          top: _this.input.el.outerHeight() + 2
        });
      };
    })(this)).on('hover', (function(_this) {
      return function(e, type) {
        if (_this.time) {
          return _this.input.highlight(type);
        }
      };
    })(this)).on('mouseout', (function(_this) {
      return function() {
        return _this.input.removeHighlight();
      };
    })(this)).on('select', (function(_this) {
      return function(e, time) {
        _this.setTime(time);
        return _this.clearButton.addClass('active');
      };
    })(this));
  };

  QingTimepicker.prototype.setTime = function(time) {
    var formattedTime, parsed;
    parsed = moment.isMoment(time) ? time : moment(time, this.opts.format, true);
    if (parsed.isValid() && !parsed.isSame(this.time)) {
      formattedTime = parsed.format(this.opts.format);
      this.time = parsed.clone();
      this.input.setValue(this.time);
      this.el.val(formattedTime);
      return this.trigger('change', [formattedTime]);
    }
  };

  QingTimepicker.prototype.getTime = function() {
    var ref;
    return (ref = this.time) != null ? ref.format(this.opts.format) : void 0;
  };

  QingTimepicker.prototype.clear = function() {
    this.time = null;
    this.input.setValue(this.time);
    this.el.val('');
    return this.clearButton.removeClass('active');
  };

  QingTimepicker.prototype.destroy = function() {
    this.el.insertAfter(this.wrapper).show().removeData('qingTimepicker');
    this.wrapper.remove();
    return $(document).off(".qing-timepicker-" + this.id);
  };

  return QingTimepicker;

})(QingModule);

extractChildComponentOpts = function(format) {
  var opts;
  opts = {};
  switch (format) {
    case 'HH:mm:ss':
      opts.showHour = opts.showMinute = opts.showSecond = true;
      break;
    case 'HH:mm':
      opts.showHour = opts.showMinute = true;
      opts.showSecond = false;
      break;
    case 'mm:ss':
      opts.showHour = false;
      opts.showMinute = opts.showSecond = true;
  }
  return opts;
};

module.exports = QingTimepicker;

},{"./input.coffee":1,"./popover.coffee":2}]},{},[]);

return b('qing-timepicker');
}));
