allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Add groovy-xml to fix "unable to resolve class groovy.xml.QName"
    dependencies {
        add("classpath", "org.codehaus.groovy:groovy-xml:3.0.21")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // project.evaluationDependsOn(":app")  // Not compatible with AGP 8.1.2
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
