class Person
{
    # Properties
    [String] $Name
    [int32] $Age

    # Static Properties
    static [String] $StaticProp = "MyStaticProp"

    # Hidden Properties
    hidden [String] $HiddenProp

    # Parameterless Constructor
    Person ()
    {
    }

    # Constructor
    Person ([String] $Name, [int32] $Age)
    {
        $this.Name = $Name
        $this.Age = $Age
    }

    # Method
    [String] getAlias()
    {
       return $this.StaticProp
    }

    # Static Method
    static [String] getConf()
    {
        return [Person]::Conference
    }

    # ToString Method
    <#[String] ToString()
    {
        return $this.Name + ":" + $this.Age
    }
    #>

    # Greet Method
    [String] Greet()
    {
        return  "Hello from " + $this.Name
    }
}