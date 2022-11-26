---
layout: post
title: C++ 反射与序列化 - 以 Piccolo 为例
description: Piccolo 源码阅读 1
categories: C++
tags: [C++]
---

## 反射

### Meta Parser - 运行时反射的代码生成和注册

暂且不关心 parser 的代码，先看由什么生成了什么。举例 `LuaComponent` 的代码：

```cpp
#pragma once

#include "runtime/function/framework/component/component.h"
#include "sol/sol.hpp"

namespace Piccolo
{
    REFLECTION_TYPE(LuaComponent)
    CLASS(LuaComponent : public Component, WhiteListFields)
    {
        REFLECTION_BODY(LuaComponent)

    public:
        LuaComponent() = default;

        void postLoadResource(std::weak_ptr<GObject> parent_object) override;

        void tick(float delta_time) override;

    protected:
        sol::state m_lua_state;

        META(Enable)
        std::string m_lua_script;

    };
} // namespace Piccolo
```

parser 生成的反射代码为：

```cpp
#pragma once
#include "runtime/function/framework/component/lua/lua_component.h"

namespace Piccolo{
    class LuaComponent;
namespace Reflection{
namespace TypeFieldReflectionOparator{
    class TypeLuaComponentOperator{
    public:
        static const char* getClassName(){ return "LuaComponent";}
        static void* constructorWithJson(const PJson& json_context){
            LuaComponent* ret_instance= new LuaComponent;
            PSerializer::read(json_context, *ret_instance);
            return ret_instance;
        }
        static PJson writeByName(void* instance){
            return PSerializer::write(*(LuaComponent*)instance);
        }
        // base class
        static int getLuaComponentBaseClassReflectionInstanceList(ReflectionInstance* &out_list, void* instance){
            int count = 1;
            out_list = new ReflectionInstance[count];
            for (int i=0;i<count;++i){
               out_list[i] = TypeMetaDef(Piccolo::Component,static_cast<LuaComponent*>(instance));
            }
            return count;
        }
        // fields
        static const char* getFieldName_m_lua_script(){ return "m_lua_script";}
        static const char* getFieldTypeName_m_lua_script(){ return "std::string";}
        static void set_m_lua_script(void* instance, void* field_value){ static_cast<LuaComponent*>(instance)->m_lua_script = *static_cast<std::string*>(field_value);}
        static void* get_m_lua_script(void* instance){ return static_cast<void*>(&(static_cast<LuaComponent*>(instance)->m_lua_script));}
        static bool isArray_m_lua_script(){ return false; }
    };
}//namespace TypeFieldReflectionOparator


    void TypeWrapperRegister_LuaComponent(){
        FieldFunctionTuple* f_field_function_tuple_m_lua_script=new FieldFunctionTuple(
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::set_m_lua_script,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::get_m_lua_script,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::getClassName,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::getFieldName_m_lua_script,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::getFieldTypeName_m_lua_script,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::isArray_m_lua_script);
        REGISTER_FIELD_TO_MAP("LuaComponent", f_field_function_tuple_m_lua_script);
        
        
        ClassFunctionTuple* f_class_function_tuple_LuaComponent=new ClassFunctionTuple(
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::getLuaComponentBaseClassReflectionInstanceList,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::constructorWithJson,
            &TypeFieldReflectionOparator::TypeLuaComponentOperator::writeByName);
        REGISTER_BASE_CLASS_TO_MAP("LuaComponent", f_class_function_tuple_LuaComponent);
    }
namespace TypeWrappersRegister{
        void LuaComponent(){ TypeWrapperRegister_LuaComponent();}
}//namespace TypeWrappersRegister

}//namespace Reflection
}//namespace Piccolo
```

可以看到 parser 为类名生成了 `getClassName` 函数：

```cpp
static const char* getClassName(){ return "LuaComponent";}
```

为 JSON 反序列化和序列化生成了 `constructorWithJson` 和 `writeByName` 函数。

为每个 `META(Enable)` 标记的字段生成了五个函数：

```cpp
// 获取字段名
static const char* getFieldName_m_lua_script(){ return "m_lua_script";}
// 获取字段类型名
static const char* getFieldTypeName_m_lua_script(){ return "std::string";}
// 将 instance 中的该字段设置为 field_value
static void set_m_lua_script(void* instance, void* field_value){ static_cast<LuaComponent*>(instance)->m_lua_script = *static_cast<std::string*>(field_value);}
// 从 instance 中获取该字段的值
static void* get_m_lua_script(void* instance){ return static_cast<void*>(&(static_cast<LuaComponent*>(instance)->m_lua_script));}
// 是否是数组
static bool isArray_m_lua_script(){ return false; }
```

而后生成了注册字段信息和类信息到符号表的函数，并由 `_generated/reflection/all_reflection.h` 中的 `TypeMetaRegister::Register` 做统一调用。

将类名和上面出现的跟某一字段相关的成员函数组绑定到一个 `std::multimap<std::string, FieldFunctionTuple*>` 中，这算是一个全局的符号表，声明在 `runtime/core/meta/reflection.cpp` 中，指某个类包含这样一个字段。字段使用 `FieldFunctionTuple` 来描述，这是 `std::tuple<SetFunction, GetFunction, GetNameFunction, GetNameFunction, GetNameFunction, GetBoolFunc>` 的别名，其每一个元素代表（下标应从 0 开始但这里通过 Markdown 生成的 `ol` 只能从 1 开始，下同）：

1. `set_FIELD`，设置字段值，函数类型是 `void(void*, void*)`
2. `get_FIELD`，获取字段值，函数类型是 `void*(void*)`
3. `getClassName`，获取其所属的类名，函数类型是 `const char*()`
4. `getFieldName_FIELD`，获取字段名，函数类型是 `const char*()`
5. `getFieldTypeName_FIELD`，获取字段类型名，函数类型是 `const char*()`
6. `isArray_FIELD`，获取是否是数组，函数类型是 `bool()`

再是类自身的绑定，将类名与自身相关的反射函数绑定到一个 `static std::map<std::string, ClassFunctionTuple*>` 中，这是类的一个全局符号表。`ClassFunctionTuple` 是 `typedef std::tuple<GetBaseClassReflectionInstanceListFunc, ConstructorWithPJson, WritePJsonByName>` 的别名，其中应包含：

1. `getCLASSNAMEBaseClassReflectionInstanceList`，获取基类反射列表，函数类型是 `int(ReflectionInstance*, void*)`
2. `constructorWithJson`，从 JSON 的反序列化，函数类型是 `void*(const PJson&)`
3. `writeByName`，序列化到 JSON，函数类型是 `PJson(void*)`

这样，由 parser 生成的所有反射的绑定均整合到了 `TypeMetaRegister::Register` 中，最后由 `PiccoloEngine::startEngine` 调用完成运行时反射。

### core/meta/reflection - 运行时反射的调用接口

#### `TypeMeta`

`TypeMeta` 的作用是为某一个反射类提供基于 `m_field_map` 等全局符号表的一层抽象，用于便捷地通过 `TypeMeta` 访问反射类的信息。

##### Constructors

`TypeMeta` 的主构造器接收一个字符串作为参数，该字符串代表尝试访问的类名，即 `type_name`。注意这个构造器是私有的，这意味着将通过其友元真正地构造一个 `TypeMeta` 对象，或使用下面说到的工厂函数。

这个构造器的功能很简单：为 `m_field_map` 中的每一个与 `type_name` 绑定的字段构造一个 `FieldAccessor`，存入 `m_fields` 中。如果在 `m_field_map` 中没有搜索到任意字段，即表示这个 `type_name` 对应的反射类无字段，判该 `TypeMeta` 非法。

##### `newMetaFromName`

工厂函数。为非友元提供创建 `TypeMeta` 的方法，由参数 `type_name` 创建一个新的 `TypeMeta`，通过公有函数访问私有构造器来绕过构造器的权限。而后返回这个将亡值。

值得注意的是，其代码为：

```cpp
TypeMeta TypeMeta::newMetaFromName(std::string type_name)
{
    TypeMeta f_type(type_name);
    return f_type;
}
```

由 `TypeMeta` 非引用类型返回一个没有强制构造为右值引用的作为广义左值（glvalue, generic left value）的将亡值（xvalue, eXpired value），在返回时不会调用其任意（拷贝/移动）构造/赋值函数进行转移，即这是一个 zero-cost 的行为。参考如下的测试代码：

```cpp
#include <iostream>
#include <string>

struct Val {
public:
    Val() { m_name = "<default>"; }
    Val(const std::string& name) {
        std::cout << "normal construct" << std::endl;
        this->m_name = name;
    }
    
    // though all these do nothing except logging
    Val(const Val& rhs) {
        std::cout << "copy constructor" << std::endl;
    }
    Val(Val&& rhs) {
        std::cout << "move constructor" << std::endl;
    }
    Val& operator=(const Val& rhs) {
        std::cout << "copy operator=" << std::endl;
        return *this;
    }
    Val& operator=(Val&& rhs) {
        std::cout << "move operator=" << std::endl;
        return *this;
    }

public:
    static Val factory(const std::string& name) {
        std::cout << "factory" << std::endl;
        Val r(name);
        return r;
    }

private:
    std::string m_name;

public:
    const std::string& getName() const {
        return m_name;
    }
};

int main() 
{
    // `m_name` can be `assigned' correctly in many ways
    auto v1 { Val::factory("name1") };
    auto v2 ( Val::factory("name2") );
    auto v3 = Val::factory("name3");

    std::cout << v1.getName() << std::endl
              << v2.getName() << std::endl
              << v3.getName() << std::endl;
}
```

输出为：

```
factory
normal construct
factory
normal construct
factory
normal construct
name1
name2
name3
```

##### `getFieldByName`

在 `m_fields` 中按名搜索字段，返回其对应的 `FieldAccessor`。

#### `FieldAccessor`

作用是为 `FieldFunctionTuple` 封装接口。

##### Constructors

主构造器接收一个 `FieldFunctionTuple`，名为 `functions`，完成下面三个行为：

- 将 `functions` 拷贝给成员 `m_functions` 备用
- 立即调用 4 of `functions`，即 `getFieldTypeName_FIELD`，获取字段类型名并赋值给 `m_field_type_name`
- 立即调用 3 of `functions`，即 `getFieldName_FIELD`，获取字段名并赋值给 `m_field_name`

##### `get` 和 `set`

`get` 封装了 1 of `m_functions`，即 `get_FIELD`，获取字段值。注意这里返回的是 Any 类型（他这里用的是 C 语言的 void*，后文均使用 Any 类型代替）。

`set` 同理。

##### `getOwnerTypeMeta`

从 2 of `m_functions` 中获取字段的类名，返回由类名构建的 `MetaType`。

##### `getFieldName`、`getFieldTypeName`、`isArrayType`

Getters。没有什么特别的。

#### `ReflectionPtr`

一个封装的反射对象，在 meta parser 生成的代码中会出现。为什么我不把它叫做指针，是因为它的用法与智能指针不完全相似，且不提供 RAII，更像是一个弱指针。

##### Fields

```cpp
std::string m_type_name {""};
T*          m_instance {nullptr};
```

对象名和对象值。

##### Assignment

`ReflectionPtr` 提供了多个 `operator=` 的 overloads，分别为：

```cpp
template<typename U> ReflectionPtr<T>& operator=(ReflectionPtr<U>&& dest);
ReflectionPtr<T>& operator=(const ReflectionPtr<T>& dest);
ReflectionPtr<T>& operator=(ReflectionPtr<T>&& dest);
```

其中，第一个是一个函数模板，用于将一个 `U` 型的对象转换为一个 `T` 型。我推测这是为了实现运行时多态。  
需要注意的是，`ReflectionPtr<T>` 会提供 `ReflectionPtr<U>` 的友元声明，否则前者无法直接访问后者的私有成员（主要是私有字段）。

第二第三个就是常规的拷贝/移动赋值。

##### Type Casting

非常有趣的是，这个类提供了 `ReflectionPtr<T>` 往 `T1*` 和 `ReflectionPtr<T1>` 转换的两组 casting operators：

```cpp
template<typename T1> explicit operator T1*();
template<typename T1> operator ReflectionPtr<T1>();
template<typename T1> explicit operator const T1*() const;
template<typename T1> operator const ReflectionPtr<T1>() const;
```

这里因为 `explicit` 的限制，`ReflectionPtr<T>` 是不能隐式类型转换到 `T1*` 的。

剩下的就是一些常规的东西了。

## 序列化和反序列化

